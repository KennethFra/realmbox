///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBPAPERFolder;
@class DBPAPERFolderSharingPolicyType;
@class DBPAPERFoldersContainingPaperDoc;

#pragma mark - API Object

///
/// The `FoldersContainingPaperDoc` struct.
///
/// Metadata about Paper folders containing the specififed Paper doc.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBPAPERFoldersContainingPaperDoc : NSObject <DBSerializable>

#pragma mark - Instance fields

/// The sharing policy of the folder containing the Paper doc.
@property (nonatomic, readonly) DBPAPERFolderSharingPolicyType * _Nullable folderSharingPolicyType;

/// The folder path. If present the first folder is the root folder.
@property (nonatomic, readonly) NSArray<DBPAPERFolder *> * _Nullable folders;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param folderSharingPolicyType The sharing policy of the folder containing
/// the Paper doc.
/// @param folders The folder path. If present the first folder is the root
/// folder.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithFolderSharingPolicyType:
                            (DBPAPERFolderSharingPolicyType * _Nullable)folderSharingPolicyType
                                                folders:(NSArray<DBPAPERFolder *> * _Nullable)folders;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
///
/// @return An initialized instance.
///
- (nonnull instancetype)init;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `FoldersContainingPaperDoc` struct.
///
@interface DBPAPERFoldersContainingPaperDocSerializer : NSObject

///
/// Serializes `DBPAPERFoldersContainingPaperDoc` instances.
///
/// @param instance An instance of the `DBPAPERFoldersContainingPaperDoc` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBPAPERFoldersContainingPaperDoc` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBPAPERFoldersContainingPaperDoc * _Nonnull)instance;

///
/// Deserializes `DBPAPERFoldersContainingPaperDoc` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBPAPERFoldersContainingPaperDoc` API object.
///
/// @return An instantiation of the `DBPAPERFoldersContainingPaperDoc` object.
///
+ (DBPAPERFoldersContainingPaperDoc * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
