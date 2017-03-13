//
//  DropboxClient.m
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//


#import "RBDropboxSync.h"
#import "DropboxMeta.h"
#import "RBReachability.h"

@implementation NSString(additions)
- (NSString *) normalizedPath {
    if ([self isEqualToString:@"/"])
        return @""; // Dropbox Root is ""
    else {
        return self;
    }
}

@end
@interface RBDropboxSync()
@property (nonatomic, copy) NSString * folderPath;
@property (nonatomic, copy) NSString * cursor;
@property (nonatomic, copy) DBClientListFilesResponseBlock responseBlock;
@property (nonatomic, assign) BOOL wasReachable;
@property (nonatomic, strong) DBRpcTask * longpollTask;
@end

@implementation RBDropboxSync

- (void) authorizeFrom:(UIViewController * _Nonnull )controller
     completionHandler:(void (^ __nullable)(BOOL success))completion
{
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                        controller:controller
     openURL:^(NSURL * _Nonnull url) {
         if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
             }];
         }
         else {
             [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] openURL:url options:@{}];
         }

    } browserAuth:false];
}

+ (RBDropboxSync *) sharedInstance {
    static RBDropboxSync *sharedInstance = nil;
    static dispatch_once_t onceTokenFileManager;
    dispatch_once(&onceTokenFileManager, ^{
        [DBClientsManager setupWithAppKey:@"vq4qvt9m0wa5536"];

        sharedInstance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(dropboxLoginChanged:) name:NotificationCloudManagerLoginChanged object:nil];

        sharedInstance = [[RBDropboxSync alloc] initWithFolderPath:@"" responseBlock:^(DBFILESListFolderResult * _Nonnull response, RBError * _Nullable error) {
            NSMutableArray * entries = [NSMutableArray array];
            
            if (error == nil) {
                for (DBFILESMetadata * metadata in response.entries) {
                    DropboxMeta * newMeta = [[DropboxMeta alloc] initWithMetadata:metadata];
                    [entries addObject:newMeta];
                }
                
                if ([entries count]) {
                    [[RLMManager sharedInstance] updateEntries:entries];
                }
            }
            else {
                [error reportErrorWhileAttempting:@"Response Block from DB"];
                // [CrashlyticsKit recordError:error];
            }
        }];
    });
    return sharedInstance;
}

- (void) dropboxLoginChanged:(NSNotification *) notification {
    
    if ([DBClientsManager authorizedClient]) {
        [self startPolling:true];
    }
    else {
        [self stopPolling];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:[self cursorKey]];
    }
}

- (void) reachabilityChanged:(NSNotification *) notification {
    
    if ([[RBReachability sharedManager] isReachable]) {
        if (!self.wasReachable) {
            self.wasReachable = true;
            [self startPolling:false];
        }
    }
    else {
        [self stopPolling];
        self.wasReachable = false;
    }
}

- (instancetype) initWithFolderPath:(NSString *)path responseBlock:(DBClientListFilesResponseBlock _Nonnull) responseBlock
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        self.wasReachable = [[RBReachability sharedManager] isReachable];

        self.folderPath = path;
        self.cursor = [[NSUserDefaults standardUserDefaults] stringForKey:[self cursorKey]];
        self.responseBlock = responseBlock;
    }
    
    return self;
}

- (NSString *) cursorKey {
    return [NSString stringWithFormat:@"cursorForPath: %@", self.folderPath];
}

- (void) setCursor:(NSString *)cursor {
    _cursor = cursor;
    [[NSUserDefaults standardUserDefaults] setObject:cursor forKey:[self cursorKey]];
}

- (BOOL) hasCursor {
    return (self.cursor).length > 0;
}

- (void) stopPolling {
    [self.longpollTask cancel];
    self.longpollTask = nil;
    self.cursor = nil;
}

- (void) startPolling:(BOOL)resync {
        
    if (![DBClientsManager authorizedClient]) {
        return;
    }
    
    if (resync || ![self hasCursor]) {
        
        [self listFolderWithCompletion:^(DBFILESListFolderResult * _Nonnull response, RBError * _Nullable error) {
            
            self.responseBlock(response, error);
            
            if (error == nil) {
                self.cursor = response.cursor;
                
                if ((response.hasMore).boolValue) {
                    [self listFolderContinue];
                }
                else {
                    [self listFolderLongpoll];
                }
            }
            else if (error.code == MTErrorCursorReset) {
                self.cursor = nil;
            }
        }];
    }
    else {
        [self listFolderContinue];
    }
}

- (void) listFolderContinue {
    [self listFolderContinueWithCompletion:^(DBFILESListFolderResult * _Nonnull response, RBError * _Nullable error) {
        
        self.cursor = response.cursor;

        self.responseBlock(response, error);

        if ((response.hasMore).boolValue) {
            [self listFolderContinue];
        }
        else {
            [self listFolderLongpoll];
        }
    }];
}

- (void) listFolderLongpoll {
    [self listFolderLongpollWithCompletion:^(DBFILESListFolderLongpollResult * _Nonnull response, RBError * _Nullable error) {
        if (response.backoff.doubleValue) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(response.backoff.doubleValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self listFolderLongpoll];
            });
        }
        else {
            [self startPolling:false];
        }
    }];
}


// This is called when we do not have a cursor.
- (void) listFolderWithCompletion:(DBClientListFilesResponseBlock _Nullable)completion
{
    dispatch_background_low(^{
        
        RLMResults * results  = [DropboxMeta allObjects];
        // If we have an empty database, dont worry about deleted items
        NSNumber * includeDeleted = [NSNumber numberWithBool:[results count] > 0 ? true : false];
        
        [[[DBClientsManager authorizedClient].filesRoutes listFolder:[self.folderPath normalizedPath]
                                                           recursive:[NSNumber numberWithBool:true]
                                                    includeMediaInfo:[NSNumber numberWithBool:false]
                                                      includeDeleted:includeDeleted
                                     includeHasExplicitSharedMembers:[NSNumber numberWithBool:false]]
         setResponseBlock:^(DBFILESListFolderResult * _Nullable response, DBFILESListFolderError * _Nullable listFolderError, DBRequestError * _Nullable requestError) {
             if (response) {
                 self.cursor = response.cursor;
             }
             completion(response, [RBError errorWithDBErrorObject:listFolderError]);
         }];
    });
}

- (void) listFolderLongpollWithCompletion:(DBClientListFilesLongpollResponseBlock _Nullable)completion
{
    if ([self.cursor length] == 0) {
        completion(nil, nil);
        return;
    }
    
    dispatch_background_low(^{
        
        [self.longpollTask cancel];
        self.longpollTask = [[DBClientsManager authorizedClient].filesRoutes listFolderLongpoll:self.cursor];
        
        __weak typeof(self) weakSelf = self;

        [self.longpollTask setResponseBlock:^(DBFILESListFolderLongpollResult * _Nullable response, DBFILESListFolderLongpollError * _Nullable longPollError, DBRequestError * _Nullable requestError) {

            if (longPollError.isReset) {
                weakSelf.cursor = nil;
            }
            
            completion(response, [RBError errorWithDBErrorObject:longPollError]);
        }];
    });
}

- (void) listFolderContinueWithCompletion:(DBClientListFilesResponseBlock)completion {

    dispatch_background_low(^{
        
        [[[DBClientsManager authorizedClient].filesRoutes listFolderContinue:self.cursor] setResponseBlock:^(DBFILESListFolderResult * _Nullable response, DBFILESListFolderContinueError * _Nullable continueError, DBRequestError * _Nullable requestError) {
            
            if (continueError.isReset) {
                self.cursor = nil;
            }
            else {
                self.cursor = response.cursor;
            }
            
            completion(response, [RBError errorWithDBErrorObject:continueError]);

        }];
    });
}
@end
