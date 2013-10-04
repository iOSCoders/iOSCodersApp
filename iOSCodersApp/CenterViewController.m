//
//  CenterViewController.m
//  iOSCoders
//
//  Created by Joe Bologna on 9/8/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "CenterViewController.h"
#import "Mazey2ViewController.h"
#import <MMDrawerBarButtonItem.h>
#import <UIViewController+MMDrawerController.h>
#import "MyScene4.h"

@interface CenterViewController() {
    NSInteger i;
    Subject *subject;
    Apps *apps;
    UIWebView *wv;
    BOOL isPad;
}

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        i = 0;
        self.view.backgroundColor = [UIColor yellowColor];
        subject = ((AppDelegate *)[UIApplication sharedApplication].delegate).subject;
        apps = ((AppDelegate *)[UIApplication sharedApplication].delegate).apps;
        [self setPage:SubjectPage];
        [self setRestorationIdentifier:@"MMExampleCenterControllerRestorationKey"];
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        isPad = (w > 320);
    }
    return self;
}

- (void)setPage:(ThePage)p {
    if (p == SubjectPage) {
        [self loadPage:subject.subject];
    } else {
        if (apps.curApp == Mazey2) {
            Mazey2ViewController *vc = [[Mazey2ViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navigationController animated:YES completion:^{}];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    [self.view addGestureRecognizer:pinch];
    
    [self setupLeftMenuButton];
    
    wv = [[UIWebView alloc] initWithFrame:self.view.frame];
    wv.delegate = self;
    [self.view addSubview:wv];
}

-(void)initZoom {
    [wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"zoom(%.2f)", (isPad ? 2.5 : 1)]];
}

- (void)loadPage:(NSString *)title {
    self.navigationItem.title = title;
    NSURL *url = [[NSBundle mainBundle] URLForResource:subject.subject withExtension:@"html"];
    [wv loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self initZoom];
}

-(void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton {
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture {
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture {
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}

-(void)zoom:(UIPinchGestureRecognizer *)sender {
#ifdef DEBUG
    printf("%s, scale: %.2f", __func__, sender.scale);
#endif
    if (sender.state == UIGestureRecognizerStateEnded) {
        [wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"zoom(%.2f);", sender.scale]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
