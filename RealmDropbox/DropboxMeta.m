//
//  DropboxFile.m
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "DropboxMeta.h"

@implementation DropboxFileSharingInfo
@end

@implementation DropboxMeta


/**
 You must supply a primary key to Realm if you want efficient searches

 @return <#return value description#>
 */
+ (NSString *)primaryKey {
    return @"path_lower";
}


/**
 Worker method to convert DBFilesMetadata into a DropboxMeta object.

 @param metadata DBFilesMetadata object
 @return instance of DropboxMeta or NIL
 */
- (instancetype) initWithMetadata:(DBFILESMetadata *) metadata {
    
    if (metadata == nil) return nil;
    
    if (self = [super init]) {
        Class metaClass = [metadata class];
        self.className = NSStringFromClass(metaClass);
        
        NSDictionary * dictionaryRepresentation = nil;
        self.isFolder = false;
        self.isDeleted = false;
        
        if (metaClass == [DBFILESFolderMetadata class]) {
            dictionaryRepresentation = [DBFILESFolderMetadataSerializer serialize:(DBFILESFolderMetadata *)metadata];
            self.isFolder = true;
        }
        else if (metaClass == [DBFILESFileMetadata class]) {
            dictionaryRepresentation = [DBFILESFileMetadataSerializer serialize:(DBFILESFileMetadata *) metadata];
            self.client_modified = @([((DBFILESFileMetadata *) metadata).clientModified timeIntervalSinceReferenceDate]);
            self.server_modified = @([((DBFILESFileMetadata *) metadata).serverModified timeIntervalSinceReferenceDate]);
        }
        else if (metaClass == [DBFILESDeletedMetadata class]) {
            dictionaryRepresentation = [DBFILESDeletedMetadataSerializer serialize:(DBFILESDeletedMetadata *) metadata];
            self.isDeleted = true;
        }
        else {
            NSString * message = [NSString stringWithFormat:@"Unhandled Class: %@", NSStringFromClass(metaClass)];
            NSAssert(false, message);
        }
        
        self.meta = [NSKeyedArchiver archivedDataWithRootObject:dictionaryRepresentation];
        
        for (NSString * key in [dictionaryRepresentation allKeys]) {
            
            if ([key isEqualToString:@"sharing_info"]) {
                DropboxFileSharingInfo * sharingInfo = [[DropboxFileSharingInfo alloc] init];
                
                NSDictionary * sharingInfoDict = dictionaryRepresentation[key];
                for (NSString * sharingInfoKey in [sharingInfoDict allKeys]) {
                    [sharingInfo setValue:sharingInfoDict[sharingInfoKey] forKey:sharingInfoKey];
                }
                
                [self setValue:sharingInfo forKey:key];

            }
            else {
                if ([key isEqualToString:@"client_modified"] ||
                    [key isEqualToString:@"server_modified"]) {
                }
                else {
                    [self setValue:dictionaryRepresentation[key] forKey:key];
                }
            }
        }
        
        self.parentFolder = [self.path_lower stringByDeletingLastPathComponent];
    }
    return self;
}


/**
 Convienience Methods

 @return Converts from timeIntervalSinceReferenceDate to NSDate
 */
- (NSDate *) lastModifiedDate {
    if (self.client_modified) {
        return [NSDate dateWithTimeIntervalSinceReferenceDate:[self.client_modified doubleValue]];
    }
    
    return nil;
}

- (BOOL) isDirectory {
    return self.isFolder;
}

- (NSString *) path {
    return self.path_display;
}

+ (instancetype _Nonnull) metaWithCloudPath:(NSString *_Nonnull) cloudPath
{
    DropboxMeta * newMeta = [[DropboxMeta alloc] init];
    newMeta.id = @"LOCAL_ID";
    newMeta.path_display = cloudPath;
    newMeta.path_lower = cloudPath.lowercaseString;
    newMeta.parentFolder = cloudPath.stringByDeletingLastPathComponent.lowercaseString;
    newMeta.name = [cloudPath lastPathComponent];
    newMeta.client_modified = @([[NSDate date] timeIntervalSinceReferenceDate]);
    newMeta.isDeleted = false;
    newMeta.isFolder = false;
    
    return newMeta;
}

@end
