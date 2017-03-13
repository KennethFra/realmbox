///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGAddFileMemberError;
@class DBSHARINGSharingFileAccessError;
@class DBSHARINGSharingUserError;

#pragma mark - API Object

///
/// The `AddFileMemberError` union.
///
/// Errors for `addFileMember`.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGAddFileMemberError : NSObject <DBSerializable>

#pragma mark - Instance fields

/// The `DBSHARINGAddFileMemberErrorTag` enum type represents the possible tag
/// states with which the `DBSHARINGAddFileMemberError` union can exist.
typedef NS_ENUM(NSInteger, DBSHARINGAddFileMemberErrorTag) {
  /// (no description).
  DBSHARINGAddFileMemberErrorUserError,

  /// (no description).
  DBSHARINGAddFileMemberErrorAccessError,

  /// The user has reached the rate limit for invitations.
  DBSHARINGAddFileMemberErrorRateLimit,

  /// The custom message did not pass comment permissions checks.
  DBSHARINGAddFileMemberErrorInvalidComment,

  /// (no description).
  DBSHARINGAddFileMemberErrorOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBSHARINGAddFileMemberErrorTag tag;

/// (no description). @note Ensure the `isUserError` method returns true before
/// accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBSHARINGSharingUserError * _Nonnull userError;

/// (no description). @note Ensure the `isAccessError` method returns true
/// before accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBSHARINGSharingFileAccessError * _Nonnull accessError;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "user_error".
///
/// @param userError (no description).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithUserError:(DBSHARINGSharingUserError * _Nonnull)userError;

///
/// Initializes union class with tag state of "access_error".
///
/// @param accessError (no description).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAccessError:(DBSHARINGSharingFileAccessError * _Nonnull)accessError;

///
/// Initializes union class with tag state of "rate_limit".
///
/// Description of the "rate_limit" tag state: The user has reached the rate
/// limit for invitations.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithRateLimit;

///
/// Initializes union class with tag state of "invalid_comment".
///
/// Description of the "invalid_comment" tag state: The custom message did not
/// pass comment permissions checks.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithInvalidComment;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithOther;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "user_error".
///
/// @note Call this method and ensure it returns true before accessing the
/// `userError` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "user_error".
///
- (BOOL)isUserError;

///
/// Retrieves whether the union's current tag state has value "access_error".
///
/// @note Call this method and ensure it returns true before accessing the
/// `accessError` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "access_error".
///
- (BOOL)isAccessError;

///
/// Retrieves whether the union's current tag state has value "rate_limit".
///
/// @return Whether the union's current tag state has value "rate_limit".
///
- (BOOL)isRateLimit;

///
/// Retrieves whether the union's current tag state has value "invalid_comment".
///
/// @return Whether the union's current tag state has value "invalid_comment".
///
- (BOOL)isInvalidComment;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString * _Nonnull)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBSHARINGAddFileMemberError` union.
///
@interface DBSHARINGAddFileMemberErrorSerializer : NSObject

///
/// Serializes `DBSHARINGAddFileMemberError` instances.
///
/// @param instance An instance of the `DBSHARINGAddFileMemberError` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGAddFileMemberError` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBSHARINGAddFileMemberError * _Nonnull)instance;

///
/// Deserializes `DBSHARINGAddFileMemberError` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGAddFileMemberError` API object.
///
/// @return An instantiation of the `DBSHARINGAddFileMemberError` object.
///
+ (DBSHARINGAddFileMemberError * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
