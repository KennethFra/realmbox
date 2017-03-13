//
//  NotesReachability.h
//
//  Created by Ken Franklin on 3/12/17.
//
//

#import "Reachability.h"

@interface RBReachability : NSObject

+ (instancetype)sharedManager;


/**
 Wraper class for Reachability. 
 */
@property (nonatomic, strong) Reachability *internetReachability;

- (void) startNotifier;
- (void) stopNotifier;
- (BOOL) isReachable;

- (NetworkStatus)currentReachabilityStatus;

@end
