//
//  DropboxClient.h
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMManager.h"

@interface NSString(additions)
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString * _Nonnull normalizedPath;
@end

typedef void (^DBClientListFilesResponseBlock)(DBFILESListFolderResult * _Nonnull response, RBError * _Nullable error);
typedef void (^DBClientListFilesLongpollResponseBlock)(DBFILESListFolderLongpollResult * _Nullable response, RBError * _Nullable error);


/**
 Dropbox intermidary class.  It will continually poll the Dropbox folder for changes.
 */
@interface RBDropboxSync : NSObject

+ (instancetype _Nonnull) sharedInstance;


/**
 Performs authentication (login) for Dropbox.

 @param controller The viewController to show the authentication panel over
 @param completion Returns success or failure depending on the response from the authenticator
 */
- (void) authorizeFrom:(UIViewController * _Nonnull )controller completionHandler:(void (^ __nullable)(BOOL success))completion;


/**
 Begins the process of retrieving all of the Dropbox meta objects and the continually watches for changes

 @param resync This will reset the sync process by invalidating the cursor
 */
- (void) startPolling:(BOOL)resync;


/**
 Stops the process of retrieving dropbox meta and stops polling.
 */
- (void) stopPolling;

@end
