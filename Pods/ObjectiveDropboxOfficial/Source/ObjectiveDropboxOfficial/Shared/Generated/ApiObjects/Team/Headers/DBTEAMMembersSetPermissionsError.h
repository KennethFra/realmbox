///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMMembersSetPermissionsError;

#pragma mark - API Object

///
/// The `MembersSetPermissionsError` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMMembersSetPermissionsError : NSObject <DBSerializable>

#pragma mark - Instance fields

/// The `DBTEAMMembersSetPermissionsErrorTag` enum type represents the possible
/// tag states with which the `DBTEAMMembersSetPermissionsError` union can
/// exist.
typedef NS_ENUM(NSInteger, DBTEAMMembersSetPermissionsErrorTag) {
  /// No matching user found. The provided team_member_id, email, or
  /// external_id does not exist on this team.
  DBTEAMMembersSetPermissionsErrorUserNotFound,

  /// Cannot remove the admin setting of the last admin.
  DBTEAMMembersSetPermissionsErrorLastAdmin,

  /// The user is not a member of the team.
  DBTEAMMembersSetPermissionsErrorUserNotInTeam,

  /// Cannot remove/grant permissions.
  DBTEAMMembersSetPermissionsErrorCannotSetPermissions,

  /// Team is full. The organization has no available licenses.
  DBTEAMMembersSetPermissionsErrorTeamLicenseLimit,

  /// (no description).
  DBTEAMMembersSetPermissionsErrorOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMMembersSetPermissionsErrorTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "user_not_found".
///
/// Description of the "user_not_found" tag state: No matching user found. The
/// provided team_member_id, email, or external_id does not exist on this team.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithUserNotFound;

///
/// Initializes union class with tag state of "last_admin".
///
/// Description of the "last_admin" tag state: Cannot remove the admin setting
/// of the last admin.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithLastAdmin;

///
/// Initializes union class with tag state of "user_not_in_team".
///
/// Description of the "user_not_in_team" tag state: The user is not a member of
/// the team.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithUserNotInTeam;

///
/// Initializes union class with tag state of "cannot_set_permissions".
///
/// Description of the "cannot_set_permissions" tag state: Cannot remove/grant
/// permissions.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithCannotSetPermissions;

///
/// Initializes union class with tag state of "team_license_limit".
///
/// Description of the "team_license_limit" tag state: Team is full. The
/// organization has no available licenses.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTeamLicenseLimit;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithOther;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "user_not_found".
///
/// @return Whether the union's current tag state has value "user_not_found".
///
- (BOOL)isUserNotFound;

///
/// Retrieves whether the union's current tag state has value "last_admin".
///
/// @return Whether the union's current tag state has value "last_admin".
///
- (BOOL)isLastAdmin;

///
/// Retrieves whether the union's current tag state has value
/// "user_not_in_team".
///
/// @return Whether the union's current tag state has value "user_not_in_team".
///
- (BOOL)isUserNotInTeam;

///
/// Retrieves whether the union's current tag state has value
/// "cannot_set_permissions".
///
/// @return Whether the union's current tag state has value
/// "cannot_set_permissions".
///
- (BOOL)isCannotSetPermissions;

///
/// Retrieves whether the union's current tag state has value
/// "team_license_limit".
///
/// @return Whether the union's current tag state has value
/// "team_license_limit".
///
- (BOOL)isTeamLicenseLimit;

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
/// The serialization class for the `DBTEAMMembersSetPermissionsError` union.
///
@interface DBTEAMMembersSetPermissionsErrorSerializer : NSObject

///
/// Serializes `DBTEAMMembersSetPermissionsError` instances.
///
/// @param instance An instance of the `DBTEAMMembersSetPermissionsError` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMMembersSetPermissionsError` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBTEAMMembersSetPermissionsError * _Nonnull)instance;

///
/// Deserializes `DBTEAMMembersSetPermissionsError` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMMembersSetPermissionsError` API object.
///
/// @return An instantiation of the `DBTEAMMembersSetPermissionsError` object.
///
+ (DBTEAMMembersSetPermissionsError * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
