//
//  AppDelegate.h
//  iOSCodersApp
//
//  Created by Joe Bologna on 10/3/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController.h>
#import "IndexObj.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MMDrawerController *drawerController;
@property (strong, nonatomic) NSMutableArray *pages, *apps;
@property (strong, nonatomic) NSString *webPages;
@property (strong, nonatomic) IndexObj *indexObj;

@end
