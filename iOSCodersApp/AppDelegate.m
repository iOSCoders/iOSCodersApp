//
//  AppDelegate.m
//  iOSCoders
//
//  Created by Joe Bologna on 9/10/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "AppDelegate.h"
#import "CenterViewController.h"
#import "LeftViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

@synthesize drawerController;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.subject = [Subject theSubject];
    self.apps = [Apps theApps];
    CenterViewController *center = [[CenterViewController alloc] init];
    LeftViewController *left = [[LeftViewController alloc] init];
    left.cvc = center;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:center];
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];

    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:left
                             rightDrawerViewController:nil];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    CGFloat w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat drawerWidth = w <= 320 ? w * 0.75 : w * 0.25;
    [self.drawerController setMaximumLeftDrawerWidth:drawerWidth];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor cyanColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
