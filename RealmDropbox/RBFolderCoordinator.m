//
//  FileCoordinator.m
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "RBFolderCoordinator.h"
#import "RBDropboxSync.h"

static RBDropboxSync * dropboxClient = nil;

@interface RBFolderCoordinator()
@property (nonatomic, strong) RLMNotificationToken * notificationToken;
@property (nonatomic, copy) NSString * _Nullable folderPath;
@property (nonatomic, copy) FolderCoordinatorResponseBlock _Nonnull responseBlock;
@end

@implementation RBFolderCoordinator

+ (instancetype) coordinatorForFolder:(NSString *) folderPath responseBlock:(FolderCoordinatorResponseBlock _Nonnull)responseBlock
{
    RLMSortDescriptor * sortDescriptor = [RLMSortDescriptor sortDescriptorWithKeyPath:@"name" ascending:true];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(parentFolder == %@) && (isDeleted == %@)", folderPath.lowercaseString, @(false)];
    
    RBFolderCoordinator * coordinator = [[RBFolderCoordinator alloc] initWithFolderPath:folderPath reponseBlock:responseBlock sortDescriptor:sortDescriptor predicate:predicate];
    
    
    return coordinator;
}
- (instancetype) initWithFolderPath:(NSString *) folderPath reponseBlock:(FolderCoordinatorResponseBlock _Nonnull) responseBlock sortDescriptor:(RLMSortDescriptor *) sortDescriptor predicate:(NSPredicate *) predicate {

    if (self = [super init]) {
        self.folderPath = folderPath;
        self.responseBlock = responseBlock;
        _sortDescriptor = sortDescriptor;
        _predicate = predicate;
    }
    
    return self;
}

-(void) startWithResync:(BOOL) resync
{
    if (self.notificationToken) return;
    
    
    if (resync) {
        [[RLMManager sharedInstance] deleteEntriesForFolder:self.folderPath];
    }
    
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [[[DropboxMeta objectsWithPredicate:self.predicate] sortedResultsUsingDescriptors:@[self.sortDescriptor]]
                              addNotificationBlock:^(RLMResults<DropboxMeta *> *results, RLMCollectionChange *changes, NSError *error) {
                                  weakSelf.responseBlock(results, changes, error);
                              }];
}

- (void) stop {
    [self.notificationToken stop];
    self.notificationToken = nil;
}

- (void) setPredicate:(NSPredicate *)predicate {
    _predicate = predicate;
}
- (void) setSortDescriptor:(RLMSortDescriptor *)sortDescriptor {
    _sortDescriptor = sortDescriptor;
}
@end
