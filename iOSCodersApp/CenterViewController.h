//
//  CenterViewController.h
//  iOSCoders
//
//  Created by Joe Bologna on 9/8/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

typedef enum {SubjectPage, AppPage} ThePage;

@interface CenterViewController : UIViewController <UIWebViewDelegate>

- (void)setPage:(ThePage)p;

@end
