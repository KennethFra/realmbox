///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBDelegate.h"
#import "DBFILESRouteObjects.h"
#import "DBSDKConstants.h"
#import "DBStoneBase.h"
#import "DBTasksImpl.h"
#import "DBTransportBaseClient+Internal.h"
#import "DBTransportDefaultClient.h"
#import "DBTransportDefaultConfig.h"

@implementation DBTransportDefaultClient {
  /// The delegate used to manage execution of all response / error code. By default, this
  /// is an instance of `DBDelegate` with the main thread queue as delegate queue.
  DBDelegate * _Nonnull _delegate;
}

@synthesize session = _session;
@synthesize secondarySession = _secondarySession;
@synthesize longpollSession = _longpollSession;

#pragma mark - Constructors

- (instancetype)initWithAccessToken:(NSString *)accessToken
                    transportConfig:(DBTransportDefaultConfig *)transportConfig {
  if (self = [super initWithAccessToken:accessToken transportConfig:transportConfig]) {
    _delegateQueue = transportConfig.delegateQueue ?: [NSOperationQueue mainQueue];
    _delegate = [[DBDelegate alloc] initWithQueue:_delegateQueue];

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 60.0;

    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:_delegate delegateQueue:_delegateQueue];
    _forceBackgroundSession = transportConfig.forceForegroundSession ? YES : NO;
    if (!_forceBackgroundSession) {
      NSString *backgroundId = [NSString stringWithFormat:@"%@.%@", kBackgroundSessionId, [NSUUID UUID].UUIDString];
      NSURLSessionConfiguration *backgroundSessionConfig =
          [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundId];
      if (transportConfig.sharedContainerIdentifier) {
        backgroundSessionConfig.sharedContainerIdentifier = transportConfig.sharedContainerIdentifier;
      }
      _secondarySession = [NSURLSession sessionWithConfiguration:backgroundSessionConfig
                                                        delegate:_delegate
                                                   delegateQueue:_delegateQueue];
    } else {
      _secondarySession = _session;
    }

    NSURLSessionConfiguration *longpollSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    longpollSessionConfig.timeoutIntervalForRequest = 480.0;

    _longpollSession =
        [NSURLSession sessionWithConfiguration:longpollSessionConfig delegate:_delegate delegateQueue:_delegateQueue];
  }
  return self;
}

#pragma mark - RPC-style request

- (DBRpcTaskImpl *)requestRpc:(DBRoute *)route arg:(id<DBSerializable>)arg {
  NSURL *requestUrl = [[self class] urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeStringWithRoute:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs accessToken:self.accessToken serializedArg:serializedArg];

  // RPC request submits argument in request body
  NSData *serializedArgData = [[self class] serializeDataWithRoute:route routeArg:arg];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:serializedArgData stream:nil];

  NSURLSession *sessionToUse = _session;

  // longpoll requests have a much longer timeout period than other requests
  if ([route class] == [DBFILESRouteObjects.DBFILESListFolderLongpoll class]) {
    sessionToUse = _longpollSession;
  }

  NSURLSessionDataTask *task = [sessionToUse dataTaskWithRequest:request];
  DBRpcTaskImpl *rpcTask =
      [[DBRpcTaskImpl alloc] initWithTask:task session:sessionToUse delegate:_delegate route:route];
  [task resume];

  return rpcTask;
}

#pragma mark - Upload-style request (NSURL)

- (DBUploadTaskImpl *)requestUpload:(DBRoute *)route arg:(id<DBSerializable>)arg inputUrl:(NSURL *)input {
  NSURL *requestUrl = [[self class] urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeStringWithRoute:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs accessToken:self.accessToken serializedArg:serializedArg];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionUploadTask *task = [_secondarySession uploadTaskWithRequest:request fromFile:input];
  DBUploadTaskImpl *uploadTask =
      [[DBUploadTaskImpl alloc] initWithTask:task session:_secondarySession delegate:_delegate route:route];
  [task resume];

  return uploadTask;
}

#pragma mark - Upload-style request (NSData)

- (DBUploadTaskImpl *)requestUpload:(DBRoute *)route arg:(id<DBSerializable>)arg inputData:(NSData *)input {
  NSURL *requestUrl = [[self class] urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeStringWithRoute:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs accessToken:self.accessToken serializedArg:serializedArg];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:input];
  DBUploadTaskImpl *uploadTask =
      [[DBUploadTaskImpl alloc] initWithTask:task session:_session delegate:_delegate route:route];
  [task resume];

  return uploadTask;
}

#pragma mark - Upload-style request (NSInputStream)

- (DBUploadTaskImpl *)requestUpload:(DBRoute *)route arg:(id<DBSerializable>)arg inputStream:(NSInputStream *)input {
  NSURL *requestUrl = [[self class] urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeStringWithRoute:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs accessToken:self.accessToken serializedArg:serializedArg];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:input];

  NSURLSessionUploadTask *task = [_session uploadTaskWithStreamedRequest:request];
  DBUploadTaskImpl *uploadTask =
      [[DBUploadTaskImpl alloc] initWithTask:task session:_session delegate:_delegate route:route];
  [task resume];

  return uploadTask;
}

#pragma mark - Download-style request (NSURL)

- (DBDownloadUrlTask *)requestDownload:(DBRoute *)route
                                   arg:(id<DBSerializable>)arg
                             overwrite:(BOOL)overwrite
                           destination:(NSURL *)destination {
  return [self requestDownload:route
                           arg:arg
                     overwrite:overwrite
                   destination:destination
               byteOffsetStart:nil
                 byteOffsetEnd:nil];
}

- (DBDownloadUrlTask *)requestDownload:(DBRoute *)route
                                   arg:(id<DBSerializable>)arg
                             overwrite:(BOOL)overwrite
                           destination:(NSURL *)destination
                       byteOffsetStart:(NSNumber *)byteOffsetStart
                         byteOffsetEnd:(NSNumber *)byteOffsetEnd {
  NSURL *requestUrl = [[self class] urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeStringWithRoute:route routeArg:arg];
  NSDictionary *headers = [self headersWithRouteInfo:route.attrs
                                         accessToken:self.accessToken
                                       serializedArg:serializedArg
                                     byteOffsetStart:byteOffsetStart
                                       byteOffsetEnd:byteOffsetEnd];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionDownloadTask *task = [_secondarySession downloadTaskWithRequest:request];
  DBDownloadUrlTaskImpl *downloadTask = [[DBDownloadUrlTaskImpl alloc] initWithTask:task
                                                                            session:_secondarySession
                                                                           delegate:_delegate
                                                                              route:route
                                                                          overwrite:overwrite
                                                                        destination:destination];
  [task resume];

  return downloadTask;
}

#pragma mark - Download-style request (NSData)

- (DBDownloadDataTask *)requestDownload:(DBRoute *)route arg:(id<DBSerializable>)arg {
  return [self requestDownload:route arg:arg byteOffsetStart:nil byteOffsetEnd:nil];
}

- (DBDownloadDataTask *)requestDownload:(DBRoute *)route
                                    arg:(id<DBSerializable>)arg
                        byteOffsetStart:(NSNumber *)byteOffsetStart
                          byteOffsetEnd:(NSNumber *)byteOffsetEnd {
  NSURL *requestUrl = [[self class] urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeStringWithRoute:route routeArg:arg];
  NSDictionary *headers = [self headersWithRouteInfo:route.attrs
                                         accessToken:self.accessToken
                                       serializedArg:serializedArg
                                     byteOffsetStart:byteOffsetStart
                                       byteOffsetEnd:byteOffsetEnd];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionDownloadTask *task = [_secondarySession downloadTaskWithRequest:request];
  DBDownloadDataTaskImpl *downloadTask =
      [[DBDownloadDataTaskImpl alloc] initWithTask:task session:_secondarySession delegate:_delegate route:route];
  [task resume];

  return downloadTask;
}

- (DBTransportDefaultConfig *)duplicateTransportConfigWithAsMemberId:(NSString *)asMemberId {
  return [[DBTransportDefaultConfig alloc] initWithAppKey:self.appKey
                                                appSecret:self.appSecret
                                                userAgent:self.userAgent
                                               asMemberId:asMemberId
                                            delegateQueue:_delegateQueue
                                   forceForegroundSession:_forceBackgroundSession];
}

#pragma mark - Session accessors and mutators

- (NSURLSession *)session {
  @synchronized(self) {
    return _session;
  }
}

- (void)setSession:(NSURLSession *)session {
  @synchronized(self) {
    _session = session;
  }
}

- (NSURLSession *)secondarySession {
  @synchronized(self) {
    return _secondarySession;
  }
}

- (void)setSecondarySession:(NSURLSession *)secondarySession {
  @synchronized(self) {
    _secondarySession = secondarySession;
  }
}

- (NSURLSession *)longpollSession {
  @synchronized(self) {
    return _longpollSession;
  }
}

- (void)setLongpollSession:(NSURLSession *)longpollSession {
  @synchronized(self) {
    _longpollSession = longpollSession;
  }
}

@end
