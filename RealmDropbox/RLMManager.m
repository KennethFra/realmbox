//
//  FileManager.m
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "RLMManager.h"
#import "DropboxMeta.h"

@implementation RLMManager

+ (RLMManager *) sharedInstance {
    static RLMManager *sharedInstance = nil;
    static dispatch_once_t onceTokenFileManager;
    dispatch_once(&onceTokenFileManager, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) updateEntries:(NSArray *) entries {
    
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        RLMRealm * realm = [RLMRealm defaultRealm];

        NSPredicate * predicateTrue = [NSPredicate predicateWithFormat:@"isDeleted == %@", [NSNumber numberWithBool:true]];
        NSPredicate * predicateFalse = [NSPredicate predicateWithFormat:@"isDeleted == %@", [NSNumber numberWithBool:false]];
        
        NSArray * deletedEntries = [entries filteredArrayUsingPredicate:predicateTrue];
        NSMutableArray * deletedItemsInDB = [NSMutableArray array];
        
        if (deletedEntries.count) {
            for (DropboxMeta * file in deletedEntries) {
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"path_lower == %@", file.path_lower];
                RLMResults * results = [DropboxMeta objectsInRealm:realm withPredicate:predicate];
                if (results.count) {
                    [deletedItemsInDB addObject:results.firstObject];
                }
            }
            
            if ([deletedItemsInDB count]) {
                NSLog(@"%@", deletedItemsInDB);
            }
        }
        
        NSArray * addedOrUpdated = [entries filteredArrayUsingPredicate:predicateFalse];
        
        [realm beginWriteTransaction];
        [realm deleteObjects:deletedItemsInDB];
        [realm addOrUpdateObjectsFromArray:addedOrUpdated];
        [realm commitWriteTransaction];
        
    });
}

- (void) deleteEntriesForFolder:(NSString *) folderPath {
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
    dispatch_async(backgroundQueue, ^{
        RLMRealm * realm = [RLMRealm defaultRealm];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"parentFolder == %@", folderPath.lowercaseString];
        RLMResults * results = [DropboxMeta objectsInRealm:realm withPredicate:predicate];

        NSMutableArray * objects = [NSMutableArray array];
        
        for (RLMObject * object in results) {
            [objects addObject:object];
        }
        
        [realm beginWriteTransaction];
        [realm deleteObjects:objects];
        [realm commitWriteTransaction];
    });
}

- (DropboxMeta *) metaForCloudPath:(NSString *) cloudPath {
    RLMResults * results = [DropboxMeta objectsWhere:@"path_lower == %@", [cloudPath lowercaseString]];
    return [results firstObject];
}

@end
