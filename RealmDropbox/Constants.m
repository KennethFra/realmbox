//
//  Constants.m
//  Realmbox
//
//  Created by Ken Franklin on 3/12/17.
//  Copyright © 2017 GnasherMobilesoft. All rights reserved.
//

#import "Constants.h"

NSNotificationName NotificationCloudManagerLoginChanged = @"NotificationCloudManagerLoginChanged";

NSString * kRootFolder = @"/";
@implementation Constants
@end


/**
 Checks to see if the code is currently executing on the main thread, if not, it dispatches to the main queue

 @param block Code to be executed in the main thread
 */
void dispatch_mainqueue(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

void dispatch_background_default(dispatch_block_t block) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        
        block();
    });
}

void dispatch_background_high(dispatch_block_t block) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        block();
    });
}

void dispatch_background_low(dispatch_block_t block) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul), ^{
        
        block();
    });
}

void dispatch_mainqueue_after(float seconds, dispatch_block_t block) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

void dispatch_async_serial_userinteractive_block(dispatch_block_t block) {
    
    static dispatch_queue_t userinteractive_serial_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, QOS_MIN_RELATIVE_PRIORITY);
        userinteractive_serial_queue = dispatch_queue_create("com.gnashermobilesoft.queue.general.qos.user-interactive", attributes);
    });
    
    dispatch_async(userinteractive_serial_queue, ^{
        @autoreleasepool {
            block();
        }
    });
}


void dispatch_async_serial_userinitiated_block(dispatch_block_t block) {
    
    static dispatch_queue_t userinitiated_serial_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, QOS_MIN_RELATIVE_PRIORITY);
        userinitiated_serial_queue = dispatch_queue_create("com.gnashermobilesoft.queue.general.qos.user-initiated", attributes);
    });
    
    dispatch_async(userinitiated_serial_queue, ^{
        @autoreleasepool {
            block();
        }
    });
}


void dispatch_async_serial_utility_block(dispatch_block_t block) {
    
    static dispatch_queue_t utility_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
        utility_queue = dispatch_queue_create("com.gnashermobilesoft.queue.general.qos.utility", attributes);
    });
    
    dispatch_async(utility_queue, ^{
        @autoreleasepool {
            block();
        }
    });
}

void dispatch_async_concurrent_utility_block(dispatch_block_t block) {
    
    static dispatch_queue_t utility_queue_concurrent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
        utility_queue_concurrent = dispatch_queue_create("com.gnashermobilesoft.queue.concurrent.general.qos.utility", attributes);
    });
    
    dispatch_async(utility_queue_concurrent, block);
}

void dispatch_async_serial_background_block(dispatch_block_t block) {
    
    static dispatch_queue_t background_serial_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, QOS_MIN_RELATIVE_PRIORITY);
        background_serial_queue = dispatch_queue_create("com.gnashermobilesoft.queue.general.qos.background", attributes);
    });
    
    dispatch_async(background_serial_queue, ^{
        @autoreleasepool {
            block();
        }
    });
}


