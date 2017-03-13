//
//  FileCoordinator.h
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMManager.h"

typedef void (^FolderCoordinatorResponseBlock)(RLMResults<DropboxMeta *> * _Null_unspecified results, RLMCollectionChange * _Null_unspecified changes, NSError * _Null_unspecified error);


/**
 Using Realm DB notifications, call the response block whenever something changes in the Realm database.  A predicate and sortDescriptor are required.
 */
@interface RBFolderCoordinator : NSObject


/**
 Convienience method to create a FolderCoordinator for the given cloud path folder.

 @param folderPath Path to the Folder
 @param responseBlock Callback to inform consumer of changes to the Realm DB
 @return Instance of type RBFolderCoodinator
 */
+ (instancetype _Nonnull) coordinatorForFolder:(NSString * _Nullable) folderPath responseBlock:(FolderCoordinatorResponseBlock _Nonnull) responseBlock;


/**
 Sort descripriptor to act upon the DropboxMeta objects that are retrvied based on the predicate.
 */
@property (nonatomic, strong) RLMSortDescriptor * _Null_unspecified sortDescriptor;


/**
 Predicate describing the type of DropboxMeta objects you would like to be notified of changes about.
 */
@property (nonatomic, strong) NSPredicate * _Null_unspecified predicate;


/**
 Adds a Realm notification and starts listening for changes

 @param resync If true, will delete all entries from the database cooresponding ot this folderPath
 */
-(void) startWithResync:(BOOL) resync;


/**
 Stops notifications of changes to the Realm DB
 */
-(void) stop;

@end
