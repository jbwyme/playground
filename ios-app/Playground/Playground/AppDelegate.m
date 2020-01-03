//
//  AppDelegate.m
//  Playground
//
//  Created by Josh Wymer on 11/11/19.
//  Copyright © 2019 Josh Wymer. All rights reserved.
//

#import "AppDelegate.h"
@import UserNotifications;
@import WebKit;

@import Mixpanel;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString* platform = @"ios";
    #if DEBUG
        platform = @"ios_sandbox";
    #endif
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    NSLog( @"Running on platform: '%@'", platform );

    
    [Mixpanel sharedInstanceWithToken:@"6888bfdec29d84ab2d36ae18c57b8535"];
//    [Mixpanel sharedInstanceWithToken:@"31f422ee381a8721982192356ba0194e"];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // Tell iOS you want your app to receive push notifications
    // This code will work in iOS 8.0 xcode 6.0 or later:
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
      [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
      [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    // This code will work in iOS 7.0 and below:
    else
    {
      [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }


    [mixpanel identify:@"josh.wymer@mixpanel.com"];
    [mixpanel track:@"Hello from iOS"
         properties:@{ @"favorite color": @"blue" }];
    [mixpanel.people set:@{@"has ios": @TRUE}];
    [mixpanel flush];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel.people addPushDeviceToken:deviceToken];
    [mixpanel track:@"Registered for push"];
    [mixpanel flush];
    NSLog(@"Registered for push");
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler {
    NSLog(@"delegating to Mixpanel to handle notification response...");
    [Mixpanel userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}

@end
