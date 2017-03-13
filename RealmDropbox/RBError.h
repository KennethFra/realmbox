//
//  RBError.h
//
//  Created by Ken Franklin on 3/12/17.
//
//

#import <Foundation/Foundation.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

typedef NS_ENUM(NSInteger, MTErrorCode) {
    MTErrorUnknown = 9000,
    MTErrorOther,
    MTErrorNotFound,
    MTErrorNotFile,
    MTErrorNotFolder,
    MTErrorInvalidPathRoot,
    MTErrorMalformedPath,
    MTErrorRestrictedContent,
    MTErrorCursorReset,
    MTErrorInvalidSelectUser,
    MTErrorInvalidAccessToken,
    MTErrorInvalidSelectAdmin,
    MTErrorUserSuspended,
    MTErrorPaperAccessDenied,
    MTErrorInvalidAccountType,
    MTErrorRateLimitTooManyRequest,
    MTErrorRateLimitTooManyWriteOperations,
    MTErrorWriteErrorMalformedPath,
    MTErrorWriteErrorConflict,
    MTErrorWriteErrorNoWritePermission,
    MTErrorWriteErrorInsufficientSpace,
    MTErrorWriteErrorDisallowedName,
    MTErrorWriteErrorOther,
    MTErrorRelocationErrorFromLookup,
    MTErrorRelocationErrorFromWrite,
    MTErrorRelocationErrorTo,
    MTErrorRelocationErrorCantCopySharedFolder,
    MTErrorRelocationErrorCantNestSharedFolder,
    MTErrorRelocationErrorCantMoveFolderIntoItself,
    MTErrorRelocationErrorTooManyFiles,
    MTErrorRelocationErrorDuplicatedOrNestedPaths,
    MTErrorRelocationErrorOther
};

#define MTErrorDomain   @"MTErrorDomain"

@interface RBError : NSError

+ (RBError *) errorWithDBErrorObject:(NSObject *) errorObject;

- (void) displayErrorWhileAttempting:(NSString *) descriptionOfWhatAppWasAttempting;

- (void) reportErrorWhileAttempting:(NSString *) descriptionOfWhatAppWasAttempting;

@end
