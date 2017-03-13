//
//  RBError.h
//
//  Created by Ken Franklin on 3/12/17.
//
//
#import <Foundation/Foundation.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>


/* 
 Converts a Dropbox V2 style error into out own class.
 */

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

/**
 Add a description of what the app was doing when the error occured.  This will be display or reported to MixPanel / Crashlytics

 @param descriptionOfWhatAppWasAttempting Text of activity occuring at time of error
 */
- (void) displayErrorWhileAttempting:(NSString *) descriptionOfWhatAppWasAttempting;

- (void) reportErrorWhileAttempting:(NSString *) descriptionOfWhatAppWasAttempting;

@end
