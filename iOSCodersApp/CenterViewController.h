//
//  CenterViewController.h
//  iOSCoders
//
//  Created by Joe Bologna on 9/8/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CenterViewController : UIViewController <UIWebViewDelegate>

- (void)setPage:(NSString *)p;
- (void)runApp:(NSString *)app;

@end
