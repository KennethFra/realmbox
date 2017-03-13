//
//  DropboxFile.h
//  DropboxCache
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import <Realm/Realm.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

typedef void (^FileManagerResponseBlock)(RLMResults * _Nonnull response, NSError * _Nullable error);
typedef void (^SuccessResponseBlock)(BOOL success, NSError * _Nullable error);
typedef void (^ContentsResponseBlock)(id _Nullable contents, NSError * _Nullable error);

@class DropboxFileSharingInfo;

@interface DropboxMeta : RLMObject

@property BOOL isDeleted;

@property BOOL isFolder;

@property NSString * _Null_unspecified parentFolder;

@property NSString * _Null_unspecified content_hash;

/// The last component of the path (including extension). This never contains a
/// slash.
@property NSString * _Null_unspecified name;
//
///// The lowercased full path in the user's Dropbox. This always starts with a
///// slash. This field will be null if the file or folder is not mounted.lights42
@property NSString * _Null_unspecified path_lower;
//
///// The cased path to be used for display purposes only. In rare instances the
@property NSString * _Null_unspecified path_display;
//
@property NSString *  _Null_unspecified id;
//

@property NSString * _Null_unspecified parent_shared_folder_id;

@property NSString * _Null_unspecified shared_folder_id;

@property DropboxFileSharingInfo * _Null_unspecified sharing_info;

///// For files, this is the modification time set by the desktop client when the
///// file was added to Dropbox. Since this time is not verified (the Dropbox
///// server stores whatever the desktop client sends up), this should only be
///// used for display purposes (such as sorting) and not, for example, to
///// determine if a file has changed or not.
@property NSNumber<RLMDouble> *  _Null_unspecified client_modified;
//
///// The last time the file was modified on Dropbox.
@property NSNumber<RLMDouble> *  _Null_unspecified server_modified;

///// A unique identifier for the current revision of a file. This field is the
///// same rev as elsewhere in the API and can be used to detect changes and avoid
///// conflicts.
@property NSString *  _Null_unspecified rev;
//
///// The file size in bytes.
@property NSNumber<RLMInt> *  _Null_unspecified size;
//
@property NSData *  _Null_unspecified meta;
//
@property NSString *  _Null_unspecified className;
//

+ (instancetype _Nonnull) metaWithCloudPath:(NSString *_Nonnull) cloudPath;

- (instancetype _Nonnull) initWithMetadata:(DBFILESMetadata * _Nonnull) metadata;

- (NSDate * _Nullable) lastModifiedDate;

- (BOOL) isDirectory;

- (NSString * _Nonnull) path;

@end


@interface DropboxFileSharingInfo : RLMObject

@property NSString * _Null_unspecified shared_folder_id;

/// ID of shared folder that holds this file.
@property NSString * _Nonnull parent_shared_folder_id;

/// The last user who modified the file. This field will be null if the user's
/// account has been deleted.
@property NSString * _Nullable modified_by;

@property NSNumber<RLMBool> * _Nonnull read_only;

/// Specifies that the folder can only be traversed and the user can only see a
/// limited subset of the contents of this folder because they don't have read
/// access to this folder. They do, however, have access to some sub folder.
@property NSNumber<RLMBool> * _Nonnull traverse_only;

/// Specifies that the folder cannot be accessed by the user.
@property NSNumber<RLMBool> * _Nonnull no_access;

@end

