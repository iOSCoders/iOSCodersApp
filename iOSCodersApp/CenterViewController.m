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
#import "GameOfWarViewController.h"

@interface CenterViewController() {
    NSInteger i;
    NSMutableArray *pages, *apps;
    NSString *webPages;
    UIWebView *wv;
    BOOL isPad;
    CGRect landscapeRect, portraitRect;
    NSString *curElement;
    NSMutableArray *download;
    NSString *curVersion, *newVersion;
    CGFloat zoom;
}

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        i = 0;
        if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"Zoom"]) {
            zoom = [[NSUserDefaults standardUserDefaults] floatForKey:@"Zoom"];
        } else {
            zoom = (isPad ? 2.5 : 1);
            [[NSUserDefaults standardUserDefaults] setFloat:zoom forKey:@"Zoom"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        self.view.backgroundColor = [UIColor cyanColor];
        pages = ((AppDelegate *)[UIApplication sharedApplication].delegate).pages;
        webPages = ((AppDelegate *)[UIApplication sharedApplication].delegate).webPages;
        [self setPage:pages[0]];
        [self setRestorationIdentifier:@"MMExampleCenterControllerRestorationKey"];
        CGFloat w = [[UIScreen mainScreen] bounds].size.width;
        isPad = (w > 320);
    }
    return self;
}

- (void)setPage:(NSString *)p {
    [wv reload];
    [self loadPage:p];
}

- (void)runApp:(NSString *)app {
    if ([app isEqualToString:@"Mazey2"]) {
        Mazey2ViewController *vc = [[Mazey2ViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigationController animated:YES completion:^{}];
    } else if ([app isEqualToString:@"GameOfWar"]) {
        GameOfWarViewController *vc = [[GameOfWarViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigationController animated:YES completion:^{}];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ not supported yet", app] delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
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
    
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    if (o == UIInterfaceOrientationLandscapeLeft || o == UIInterfaceOrientationLandscapeLeft) {
        landscapeRect = [[UIScreen mainScreen] bounds];
        portraitRect = CGRectMake(landscapeRect.origin.x, landscapeRect.origin.y, landscapeRect.size.height, landscapeRect.size.width);
        wv.frame = landscapeRect;
    } else {
        portraitRect = [[UIScreen mainScreen] bounds];
        landscapeRect = CGRectMake(portraitRect.origin.x, portraitRect.origin.y, portraitRect.size.height, portraitRect.size.width);
        wv.frame = portraitRect;
    }
}

- (void)doZoom:(CGFloat)z {
    zoom = z;
    [[NSUserDefaults standardUserDefaults] setFloat:z forKey:@"Zoom"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *s = [NSString stringWithFormat:@"var pt = 6 + ((16 / 7) * %.2f); document.styleSheets[0].cssRules[0].style.fontSize = pt.toFixed(2) + 'pt';", z];
    NSString *rc = [wv stringByEvaluatingJavaScriptFromString:s];
    NSLog(@"rc: %@", rc);
}

-(void)initZoom {
    [self doZoom:zoom];
}

- (void)loadPage:(NSString *)title {
    NSString *f = title;
    if (title.pathExtension.length == 0) {
        f = [title stringByAppendingPathExtension:@"xml"];
    }
    self.navigationItem.title = f.stringByDeletingPathExtension;
    NSURL *url = [NSURL fileURLWithPath:[webPages stringByAppendingPathComponent:f]];
    [wv loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    [self initZoom];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"%s, %@, %@", __func__, webView, error);
#endif
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}

- (NSString *)tString:(UIWebViewNavigationType)t {
    switch (t) {
        case UIWebViewNavigationTypeLinkClicked: return @"UIWebViewNavigationTypeLinkClicked";
        case UIWebViewNavigationTypeFormSubmitted: return @"UIWebViewNavigationTypeFormSubmitted";
        case UIWebViewNavigationTypeBackForward: return @"UIWebViewNavigationTypeBackForward";
        case UIWebViewNavigationTypeReload: return @"UIWebViewNavigationTypeReload";
        case UIWebViewNavigationTypeFormResubmitted: return @"UIWebViewNavigationTypeFormResubmitted";
        case UIWebViewNavigationTypeOther: return @"UIWebViewNavigationTypeOther";
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
#ifdef DEBUG
    NSLog(@"%s", __func__);
    NSLog(@"%@, %@", [self tString:navigationType], request);
#endif
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
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
        [self doZoom:sender.scale];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
#ifdef DEBUG
    printf("%s", __func__);
#endif
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        wv.frame = landscapeRect;
    } else {
        wv.frame = portraitRect;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
