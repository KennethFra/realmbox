///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBFILESMetadata;
@class DBFILESRelocationResult;

#pragma mark - API Object

///
/// The `RelocationResult` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBFILESRelocationResult : NSObject <DBSerializable>

#pragma mark - Instance fields

/// (no description).
@property (nonatomic, readonly) DBFILESMetadata * _Nonnull metadata;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param metadata (no description).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithMetadata:(DBFILESMetadata * _Nonnull)metadata;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `RelocationResult` struct.
///
@interface DBFILESRelocationResultSerializer : NSObject

///
/// Serializes `DBFILESRelocationResult` instances.
///
/// @param instance An instance of the `DBFILESRelocationResult` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBFILESRelocationResult` API object.
///
+ (NSDictionary * _Nonnull)serialize:(DBFILESRelocationResult * _Nonnull)instance;

///
/// Deserializes `DBFILESRelocationResult` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBFILESRelocationResult` API object.
///
/// @return An instantiation of the `DBFILESRelocationResult` object.
///
+ (DBFILESRelocationResult * _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end
