//
//  ViewController.m
//  Mazey2
//
//  Created by Joe Bologna on 8/31/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import "Mazey2ViewController.h"
#import "MyScene4.h"

#define MAZEY2 9999

@implementation Mazey2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Mazey (swipe right to exit)";
    
    UISwipeGestureRecognizer *s = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bye)];
    [self.view addGestureRecognizer:s];
    
    // Configure the view.
    SKView *skView = [[SKView alloc] initWithFrame:self.view.frame];
    skView.tag = MAZEY2;
    [self.view addSubview:skView];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    // Create and configure the scene.
    SKScene *scene = [MyScene4 sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

//    // Present the scene.
    [skView presentScene:scene];
}

-(void)bye {
    SKView *s = [self.view subviews][0];
    [s.scene removeAllActions];
    [s.scene removeAllChildren];
    s.paused = YES;
    s = nil;
    SKView *v = (SKView *)[self.view viewWithTag:MAZEY2];
    [v removeFromSuperview];
    [self performSelector:@selector(adios) withObject:self afterDelay:1];
}

- (void)adios {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
