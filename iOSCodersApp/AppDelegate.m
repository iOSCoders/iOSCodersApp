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

#ifdef DEBUG
#define NACTIVITYCHECKS 2
#else
#define NACTIVITYCHECKS 10
#endif
static int activity = 0;

@interface AppDelegate() {
    NSString *curElement;
    NSMutableArray *download;
    NSString *curVersion, *newVersion;
}
@end

@implementation AppDelegate

@synthesize drawerController;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.webPages = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"WebPages"];
    [self cacheIndex];
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
    if ((activity++ % NACTIVITYCHECKS) == 0) {
        NSLog(@"%s getting updates", __func__);
        [self cacheIndex];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark XML Handlers
/*
 The WebPages are distributed with the app. The Copy Files build phase copies the original versions to the ./WebPages directory.
 A completely new set of pages may be available on the website. These files should replace all the files in the WebPages directory.
 This is accomplished by downloading the entire folder to ./WebPages.update, then moving the files to ./WebPages.
 If an error occurs during the download, the ./WebPages folder is left intact.
 */

- (void)downloadUpdates {
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
    
    curElement = @"";
    download = [NSMutableArray array];
    
    // get the list of files to download from the server.
    NSURL *updateUrl = [self webSiteURLFor:@"update.xml"];
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:updateUrl];
    p.delegate = self;
    if (![p parse]) {
        NSLog(@"%s, parsing %@ failed", __func__, updateUrl.path);
        NSLog(@"Skipping update");
    } else {
#pragma warning need to check a timestamp or something to avoid unnecessary i/o
        // download them into the .update folder
        NSURL *updateFolder = [NSURL fileURLWithPath:[self.webPages stringByAppendingPathExtension:@"update"]];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:updateFolder error:&error];
        [[NSFileManager defaultManager] createDirectoryAtURL:updateFolder withIntermediateDirectories:NO attributes:nil error:nil];
        BOOL ok = YES;
        for (NSString *f in download) {
            NSURL *url = [self webSiteURLFor:f];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSString *tmpFile = [NSTemporaryDirectory() stringByAppendingString:f];
            [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
            [data writeToFile:tmpFile atomically:YES];
            ok = [[NSFileManager defaultManager] copyItemAtPath:tmpFile toPath:[updateFolder.path stringByAppendingPathComponent:f] error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
            if (!ok) break;
        }
        
        // if the update files were downloaded ok, then move them
        if (ok) {
            [[NSFileManager defaultManager] removeItemAtPath:self.webPages error:nil];
            [[NSFileManager defaultManager] moveItemAtPath:updateFolder.path toPath:self.webPages error:nil];
            NSURL *url = [NSURL fileURLWithPath:[self.webPages stringByAppendingPathComponent:@"index.xml"]];
            NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
            [p parse];
        }
    }
}

- (NSURL *)webSiteURLFor:(NSString *)f {
    return [[NSURL alloc] initWithScheme:@"http" host:@"focusedforsuccess.net" path:[@"/iOSCoders/WebPages" stringByAppendingPathComponent:f]];
}

- (void)cacheIndex {
    [self downloadUpdates];
    self.pages = [NSMutableArray array];
    self.apps = [NSMutableArray array];
    NSURL *url = [NSURL fileURLWithPath:[self.webPages stringByAppendingPathComponent:@"index.xml"]];
    NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
    p.delegate = self;
    curElement = @"";
    if (![p parse]) {
        NSLog(@"%s, parsing %@ failed", __func__, url.path);
        abort();
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    curElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([curElement isEqualToString:@"item"]) {
        NSLog(@"%@: %@\n", curElement, string);
        [self.pages addObject:string];
    } else if ([curElement isEqualToString:@"download"]) {
            NSLog(@"%@: %@\n", curElement, string);
            [download addObject:string];
    } else if ([curElement isEqualToString:@"app"]) {
        NSLog(@"%@: %@\n", curElement, string);
        [self.apps addObject:string];
    } else if ([curElement isEqualToString:@"version"]) {
        NSLog(@"%@: %@\n", curElement, string);
        curVersion = string;
    } else if ([curElement isEqualToString:@"newversion"]) {
        NSLog(@"%@: %@\n", curElement, string);
        newVersion = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    curElement = @"";
}
@end
