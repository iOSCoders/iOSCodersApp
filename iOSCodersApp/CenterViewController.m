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
    NSMutableArray *pages;
    NSString *webPages;
    UIWebView *wv;
    BOOL isPad;
    CGRect landscapeRect, portraitRect;
}

@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        i = 0;
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
    [self loadPage:p];
}

- (void)runApp:(NSString *)app {
    if ([app isEqualToString:@"Mazey2"]) {
        Mazey2ViewController *vc = [[Mazey2ViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigationController animated:YES completion:^{}];
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
    NSString *s = [NSString stringWithFormat:@"var pt = 8 + ((16 / 7) * %.2f); document.styleSheets[0].cssRules[0].style.fontSize = pt.toFixed(2) + 'pt';", z];
    NSString *rc = [wv stringByEvaluatingJavaScriptFromString:s];
#ifdef DEBUG
    NSLog(@"rc: %@", rc);
#endif
}

-(void)initZoom {
    [self doZoom:(isPad ? 2.5 : 1)];
}

- (void)loadPage:(NSString *)title {
    self.navigationItem.title = title;
    NSURL *url = [NSURL fileURLWithPath:[[webPages stringByAppendingPathComponent:title] stringByAppendingPathExtension:@"xml"]];
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
