//
//  Constants.h
//  Realmbox
//
//  Created by Toptal on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_MAIN_THREAD     if ([NSThread isMainThread]) NSLog(@"=== ON MAIN THREAD")

extern NSNotificationName NotificationCloudManagerLoginChanged;

void dispatch_mainqueue(dispatch_block_t block);
void dispatch_mainqueue_after(float seconds, dispatch_block_t block);
void dispatch_background_default(dispatch_block_t block);
void dispatch_background_low(dispatch_block_t block);

/**
 Lazily creates a serial queues with the named QoS class onto which
 the block is dispatched asynchronously.
 */
void dispatch_async_serial_userinteractive_block(dispatch_block_t block);
void dispatch_async_serial_userinitiated_block(dispatch_block_t block);
void dispatch_async_serial_utility_block(dispatch_block_t block);
void dispatch_async_serial_background_block(dispatch_block_t block);
void dispatch_background_high(dispatch_block_t block);


extern NSString * kRootFolder;

@interface Constants : NSObject
@end


