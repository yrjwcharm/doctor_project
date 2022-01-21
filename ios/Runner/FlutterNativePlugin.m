//
//  FlutterNativePlugin.m
//  Runner
//
//  Created by mac on 2022/1/14.
//

#import "FlutterNativePlugin.h"
#import "AppDelegate.h"
#import "VideoChatSingleVC.h"


@implementation FlutterNativePlugin
+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"flutterPrimordialBrige"
                                binaryMessenger:[registrar messenger]];
    FlutterNativePlugin* instance = [[FlutterNativePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"jumpToCallVideo" isEqualToString:call.method]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            VideoChatSingleVC*vc=[[VideoChatSingleVC alloc]init];
            AppDelegate*delegate = (AppDelegate *)([UIApplication sharedApplication].delegate) ;
          UINavigationController *rootNav = delegate.navigationController;
          [rootNav pushViewController:vc animated:YES];
        });
        
    } else {
        result(FlutterMethodNotImplemented);
    }
}
@end
