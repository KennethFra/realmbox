//
//  RBError.m
//
//  Created by Ken Franklin on 3/12/17.
//
//

#import "RBError.h"
#import "UIAlertController+Window.h"
// Install Crashlytics to enable crash and error reporting
// #import <Crashlytics/Crashlytics.h>

@implementation RBError

- (void) displayErrorWhileAttempting:(NSString *) descriptionOfWhatAppWasAttempting
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:self.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    [alert show];
    
    [self reportErrorWhileAttempting:descriptionOfWhatAppWasAttempting];
}

- (void) reportErrorWhileAttempting:(NSString *) descriptionOfWhatAppWasAttempting
{
    // Install Crashlytics to enable crash and error reporting
    // [CrashlyticsKit recordError:self withAdditionalUserInfo:@{@"During Event" : descriptionOfWhatAppWasAttempting}];
}

+ (RBError *) errorWithDBErrorObject:(NSObject *) errorObject {
    
    if (errorObject == nil) return nil;
    
    if ([errorObject isKindOfClass:[DBFILESListFolderError class]]) {
        return [RBError errorWithListFolderError:(DBFILESListFolderError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESListFolderLongpollError class]]) {
        return [RBError errorWithLongPollError:(DBFILESListFolderLongpollError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESListFolderContinueError class]]) {
        return [RBError errorWithFolderContinueError:(DBFILESListFolderContinueError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESLookupError class]]) {
        return [RBError errorWithLookupError:(DBFILESLookupError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBRequestError class]]) {
        return [RBError errorWithRequestError:(DBRequestError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESUploadError class]]) {
        return [RBError errorWithUploadError:(DBFILESUploadError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESGetMetadataError class]]) {
        return [RBError errorWithGetMetadateError:(DBFILESGetMetadataError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESDownloadError class]]) {
        return [RBError errorWithDownloadError:(DBFILESDownloadError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESDeleteError class]]) {
        return [RBError errorWithDeleteError:(DBFILESDeleteError *)errorObject];
    }
    else if ([errorObject isKindOfClass:[DBFILESRelocationError class]]) {
        return [RBError errorWithRelocationError:(DBFILESRelocationError *)errorObject];
    }
    else {
        NSString * message = [NSString stringWithFormat:@"Unsupported error type: %@", NSStringFromClass(errorObject.class)];
        NSAssert(false, message);
    }
    
    return nil;
}

+ (RBError *) errorWithGetMetadateError:(DBFILESGetMetadataError *) getMetaDataError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (getMetaDataError.isPath) {
        return [RBError errorWithLookupError:getMetaDataError.path];
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];

}



+ (RBError *) errorWithRelocationError:(DBFILESRelocationError *) relocationError {
    
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (relocationError.isOther) {
        code = MTErrorOther;
        message = @"Unknown Error Occurred";
    }
    else if (relocationError.isFromWrite) {
        return [RBError errorWithWriteError:relocationError.fromWrite];
    }
    else if (relocationError.isTo) {
        return [RBError errorWithWriteError:relocationError.to];
    }
    else if (relocationError.isTooManyFiles) {
        code = MTErrorRelocationErrorTooManyFiles;
        message = @"The operation would involve more than 10,000 files and folders";
    }
    else if (relocationError.isFromLookup) {
        return [RBError errorWithLookupError:relocationError.fromLookup];
    }
    else if (relocationError.isCantCopySharedFolder) {
        code = MTErrorRelocationErrorCantCopySharedFolder;
        message = @"Shared folders can't be copied.";
    }
    else if (relocationError.isCantMoveFolderIntoItself) {
        code = MTErrorRelocationErrorCantMoveFolderIntoItself;
        message = @"You cannot move a folder into itself.";
    }
    else if (relocationError.isCantNestSharedFolder) {
        code = MTErrorRelocationErrorCantNestSharedFolder;
        message = @"You cannot nest a shared folder.";
    }
    else if (relocationError.isDuplicatedOrNestedPaths) {
        code = MTErrorRelocationErrorDuplicatedOrNestedPaths;
        message = @"There are duplicated/nested paths among `fromPath` in `toPath`.";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}


+ (RBError *) errorWithLookupError:(DBFILESLookupError *) lookupError {
    
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (lookupError.isOther) {
        code = MTErrorOther;
        message = @"Unknown Error Occurred";
    }
    else if (lookupError.isNotFound) {
        code = MTErrorNotFound;
        message = @"The specified item was not found";
    }
    else if (lookupError.isNotFile) {
        code = MTErrorNotFile;
        message = @"The specified item was not a file";
    }
    else if (lookupError.isNotFolder) {
        code = MTErrorNotFolder;
        message = @"The specified item was not a folder";
    }
    else if (lookupError.isInvalidPathRoot) {
        code = MTErrorInvalidPathRoot;
        message = @"The specified item had an invalid root path";
    }
    else if (lookupError.isMalformedPath) {
        code = MTErrorMalformedPath;
        message = @"The specified item had a malformed path";
    }
    else if (lookupError.isRestrictedContent) {
        code = MTErrorRestrictedContent;
        message = @"The specified item is restricted content";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithFolderContinueError:(DBFILESListFolderContinueError * _Nullable) listFolderError {
    
    if (listFolderError.isPath) {
        DBFILESLookupError * errorPath = listFolderError.path;
        return [RBError errorWithLookupError:errorPath];
    }
    else if (listFolderError.isOther) {
        NSString * message = @"Unknown Error Occurred";
        MTErrorCode code = MTErrorUnknown;
        NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
        
        return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
    }
    
    return nil;
}

+ (RBError *) errorWithListFolderError:(DBFILESListFolderError * _Nullable) listFolderError {
    if (listFolderError == nil) return nil;
    
    if (listFolderError.isPath) {
        DBFILESLookupError * errorPath = listFolderError.path;
        return [RBError errorWithLookupError:errorPath];
    }
    else if (listFolderError.isOther) {
        NSString * message = @"Unknown Error Occurred";
        MTErrorCode code = MTErrorUnknown;
        NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
        
        return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
    }
    
    return nil;
}

+ (RBError *) errorWithLongPollError:(DBFILESListFolderLongpollError * _Nullable) longPollError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (longPollError.isOther) {
        code = MTErrorOther;
        message = @"Unknown Error Occurred";
    }
    else if (longPollError.isReset) {
        code = MTErrorCursorReset;
        message = @"Cursor was reset";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithRequestError:(DBRequestError * _Nullable) requestError {
    
    if ([requestError isInternalServerError]) {
        DBRequestInternalServerError *internalServerError = [requestError asInternalServerError];
        NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : internalServerError.description };
        return [RBError errorWithDomain:MTErrorDomain code:[internalServerError.statusCode integerValue] userInfo:userInfo];
    } else if ([requestError isBadInputError]) {
        DBRequestBadInputError *badInputError = [requestError asBadInputError];
        NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : badInputError.description };
        return [RBError errorWithDomain:MTErrorDomain code:[badInputError.statusCode integerValue] userInfo:userInfo];
    } else if ([requestError isAuthError]) {
        DBRequestAuthError *authError = [requestError asAuthError];
        return [RBError errorWithAuthError:authError.structuredAuthError];
    } else if ([requestError isAccessError]) {
        DBRequestAccessError *accessError = (DBRequestAccessError*)[requestError asAccessError];
        return [RBError errorWithAccessError:accessError.structuredAccessError];
    } else if ([requestError isRateLimitError]) {
        DBRequestRateLimitError *rateLimitError = [requestError asRateLimitError];
        return [RBError errorWithRateLimitReason:rateLimitError.structuredRateLimitError.reason];
    } else if ([requestError isHttpError]) {
        DBRequestHttpError *genericHttpError = [requestError asHttpError];
        NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : genericHttpError.errorContent };
        return [RBError errorWithDomain:MTErrorDomain code:[genericHttpError.statusCode integerValue] userInfo:userInfo];
    } else if ([requestError isClientError]) {
        DBRequestClientError *genericLocalError = [requestError asClientError];
        return [RBError errorWithClientError: genericLocalError];
    }
    
    return nil;

}

+ (RBError *) errorWithClientError:(DBRequestClientError *) clientError {
    
    NSError * error = clientError.nsError;
    
    return [RBError errorWithDomain:MTErrorDomain code:error.code userInfo:error.userInfo];
}

+ (RBError *) errorWithAuthError:(DBAUTHAuthError *) authError {
    
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (authError.isOther) {
        code = MTErrorOther;
        message = @"Unknown Error Occurred";
    }
    else if (authError.isUserSuspended) {
        code = MTErrorUserSuspended;
        message = @"User has been suspended.";
    }
    else if (authError.isInvalidSelectUser) {
        code = MTErrorInvalidSelectUser;
        message = @"Invalid Select User";
    }
    else if (authError.isInvalidAccessToken) {
        code = MTErrorInvalidAccessToken;
        message = @"Invalid Access Token";
    }
    else if (authError.isInvalidSelectAdmin) {
        code = MTErrorInvalidSelectAdmin;
        message = @"Invalid Select Admin";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithAccessError:(DBAUTHAccessError *) accessError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (accessError.isPaperAccessDenied) {
        code = MTErrorPaperAccessDenied;
        message = @"Paper Acessed Denied";
    }
    else if (accessError.isInvalidAccountType) {
        code = MTErrorInvalidAccountType;
        message = @"Invalid Account Type.";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithDeleteError:(DBFILESDeleteError *) deleteError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (deleteError.isPathWrite) {
        return [RBError errorWithWriteError:deleteError.pathWrite];
    }
    else if (deleteError.isPathLookup) {
        return [RBError errorWithLookupError:deleteError.pathLookup];
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithWriteError:(DBFILESWriteError *) writeError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (writeError.isMalformedPath) {
        code = MTErrorWriteErrorMalformedPath;
        message = @"Write Error: Malformed Path";
    }
    else if (writeError.isConflict) {
        message = @"Couldn't write to the target path because there was something in the way";
        code = MTErrorWriteErrorConflict;
    }
    else if (writeError.isNoWritePermission) {
        message = @"The user doesn't have permissions to write to the target location.";
        code = MTErrorWriteErrorNoWritePermission;
    }
    else if (writeError.isDisallowedName) {
        message = @"Dropbox will not save the file or folder because of its name.";
        code = MTErrorWriteErrorDisallowedName;
    }
    else if (writeError.isInsufficientSpace) {
        message = @"The user doesn't have enough available space (bytes) to write more data.";
        code = MTErrorWriteErrorInsufficientSpace;
    }
    else if (writeError.isOther) {
        code = MTErrorOther;
        message = @"Unknown Error Occurred";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithDownloadError:(DBFILESDownloadError *) downloadError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (downloadError.isPath) {
        return [RBError errorWithLookupError:downloadError.path];
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];
}

+ (RBError *) errorWithUploadError:(DBFILESUploadError *) uploadError {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;

    if (uploadError.isPath) {
        DBFILESUploadWriteFailed * writeError = uploadError.path;
        return [RBError errorWithWriteError:writeError.reason];
    }
    else if (uploadError.isOther) {
        code = MTErrorOther;
        message = @"Unknown Error Occurred";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];

}

+ (RBError *) errorWithRateLimitReason:(DBAUTHRateLimitReason *) rateLimitReason {
    NSString * message = @"Unknown Error Occurred";
    MTErrorCode code = MTErrorUnknown;
    
    if (rateLimitReason.isTooManyRequests) {
        code = MTErrorRateLimitTooManyRequest;
        message = @"Rate limit error. Too many requests.";
    }
    else if (rateLimitReason.isTooManyWriteOperations) {
        code = MTErrorRateLimitTooManyWriteOperations;
        message = @"Rate limit error. Too many write operations.";
    }
    
    NSDictionary *userInfo = @{  NSLocalizedFailureReasonErrorKey : message };
    
    return [RBError errorWithDomain:MTErrorDomain code:code userInfo:userInfo];

}
@end
