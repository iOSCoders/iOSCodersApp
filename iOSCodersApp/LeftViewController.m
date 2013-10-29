//
//  LeftViewController.m
//  iOSCoders
//
//  Created by Joe Bologna on 9/8/13.
//  Copyright (c) 2013 Joe Bologna. All rights reserved.
//

#import <MMDrawerController.h>
#import "CenterViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"

@interface LeftViewController() {
    NSMutableArray *pages, *apps;
    NSString *curElement;
    NSMutableArray *download;
    NSString *curVersion, *newVersion;
    NSString *webPages;
}

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor cyanColor];
        self.title = @"Blue View";
        [self setRestorationIdentifier:@"MMExampleLeftSideDrawerController"];
        apps = ((AppDelegate *)[UIApplication sharedApplication].delegate).apps;
        pages = ((AppDelegate *)[UIApplication sharedApplication].delegate).pages;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return pages.count;
    }
    if (section == 1){
        return apps.count;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Subjects";
    }
    if (section == 1){
        return @"Apps";
    }
    return @"Options";
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    // Set up the cell.
    if (indexPath.section == 0) {
        cell.textLabel.text = pages[indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = apps[indexPath.row];
    }
    else {
        cell.textLabel.text = @"Update";
    }
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMDrawerController *pvc = (MMDrawerController *)self.parentViewController;
    if (indexPath.section == 2) {
        [self update];
    }
    [pvc closeDrawerAnimated:YES completion:^(BOOL finished) {
        printf("closed.\n");
        if (indexPath.section == 0) {
            [self.cvc setPage:pages[indexPath.row]];
        } else if (indexPath.section == 1) {
            [self.cvc setPage:pages[indexPath.row]];
        } else {
            abort();
        }
    }];
}

#pragma mark XML Handlers
/*
 The WebPages are distributed with the app. The Copy Files build phase copies the original versions to the ./WebPages directory.
 A completely new set of pages may be available on the website. These files should replace all the files in the WebPages directory.
 This is accomplished by downloading the entire folder to ./WebPages.update, then moving the files to ./WebPages.
 If an error occurs during the download, the ./WebPages folder is left intact.
 */

- (void)update {
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
        NSURL *updateFolder = [NSURL fileURLWithPath:[webPages stringByAppendingPathExtension:@"update"]];
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
            [[NSFileManager defaultManager] removeItemAtPath:webPages error:nil];
            [[NSFileManager defaultManager] moveItemAtPath:updateFolder.path toPath:webPages error:nil];
            NSURL *url = [NSURL fileURLWithPath:[webPages stringByAppendingPathComponent:@"index.xml"]];
            NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
            [p parse];
        }
    }
}

- (NSURL *)webSiteURLFor:(NSString *)f {
    return [[NSURL alloc] initWithScheme:@"http" host:@"focusedforsuccess.net" path:[@"/iOSCoders/WebPages" stringByAppendingPathComponent:f]];
}

- (void)cacheIndex {
    [self update];
    pages = [NSMutableArray array];
    apps = [NSMutableArray array];
    NSURL *url = [NSURL fileURLWithPath:[webPages stringByAppendingPathComponent:@"index.xml"]];
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
        [pages addObject:string];
    } else if ([curElement isEqualToString:@"download"]) {
        NSLog(@"%@: %@\n", curElement, string);
        [download addObject:string];
    } else if ([curElement isEqualToString:@"app"]) {
        NSLog(@"%@: %@\n", curElement, string);
        [apps addObject:string];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
