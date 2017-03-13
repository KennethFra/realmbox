//
//  FileManager.h
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "DropboxMeta.h"

@interface RLMManager : NSObject

/**
 Singleton for RLMManager

 @return Singleton instance of RLMManager
 */
+ (RLMManager * _Nonnull) sharedInstance;


/**
 Given an array of DBFilesMeta, convert them to DropboxMeta and store / update them in Realm database.

 @param entries Array of DBFilesMeta as provided from API
 */
- (void) updateEntries:(NSArray <DBFILESMetadata *> * _Nullable) entries;


/**
 Convieniece method to query Realm DB for a specific DropboxMeta object.

 @param cloudPath Path for file in Dropbox
 @return DropboxMeta cooresponding to the cloud path
 */
- (DropboxMeta * _Nullable) metaForCloudPath:(NSString * _Nonnull) cloudPath;


/**
 Given a folder path, delete all of the entries in the Realm DB in that folder.

 @param folderPath Cloud path for the folder
 */
- (void) deleteEntriesForFolder:(NSString * _Nullable) folderPath;
@end


