//
//  AppDelegate.h
//  iOSCodersApp
//
//  Created by Joe Bologna on 10/3/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMDrawerController.h>
#import "Subject.h"
#import "Apps.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property MMDrawerController *drawerController;
//@property (strong, nonatomic) Subject *subject;
//@property (strong, nonatomic) Apps *apps;
@property (strong, nonatomic) NSMutableArray *pages, *apps;

@end
