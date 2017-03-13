//
//  NotesReachability.m
//
//  Created by Ken Franklin on 3/12/17.
//
//

#import "RBReachability.h"

@interface RBReachability() {
    BOOL isMonitoring;
}
@end

@implementation RBReachability

+ (instancetype)sharedManager {
    static RBReachability *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[RBReachability alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:_sharedManager selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        _sharedManager.internetReachability = [Reachability reachabilityForInternetConnection];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}


- (void) applicationDidBecomeActive:(NSNotification *) notification {
    [self startNotifier];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
    }
}

- (BOOL) isReachable {
    NetworkStatus status = [self currentReachabilityStatus];
    
    return (status == ReachableViaWiFi) || (status == ReachableViaWWAN);
}

- (void) startNotifier {
    if (isMonitoring) return;
    
   [self.internetReachability startNotifier];
    
    isMonitoring = true;
}

- (void) stopNotifier {
    if (!isMonitoring) return;
    
    [self.internetReachability stopNotifier];
    
    isMonitoring = false;
}

- (NetworkStatus)currentReachabilityStatus {
    return [self.internetReachability currentReachabilityStatus];
}


@end
