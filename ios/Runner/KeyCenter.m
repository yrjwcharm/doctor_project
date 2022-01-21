//
//  KeyCenter.m
//  ZegoExpressExample
//
//  Created by Patrick Fu on 2019/11/11.
//  Copyright © 2019 Zego. All rights reserved.
//

#import "KeyCenter.h"

@implementation KeyCenter

// Developers can get appID from admin console.
// admin console: https://console.zego.im/dashboard
// for example:
// return 123456789;
+ (unsigned int)appID {
    return 2402989282;
}

// Developers can get appSign from admin console.
// for example:
// return @"abcdefghijklmnopqrstuvwzyv123456789abcdefghijklmnopqrstuvwzyz123";
+ (NSString *)appSign {
    return @"8bc29946f308dc6d3a96db88aae65ff916b45200330b0a5c32ba70f9e7509698";
}

@end
