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
#import "Subject.h"
#import "Apps.h"
#import "AppDelegate.h"

@interface LeftViewController() {
//    Subject *subject;
//    Apps *apps;
    NSArray *pages;
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
//        subject = ((AppDelegate *)[UIApplication sharedApplication].delegate).subject;
//        apps = ((AppDelegate *)[UIApplication sharedApplication].delegate).apps;
        pages = ((AppDelegate *)[UIApplication sharedApplication].delegate).pages;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return pages.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Subjects";
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
    cell.textLabel.text = pages[indexPath.row];
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMDrawerController *pvc = (MMDrawerController *)self.parentViewController;
    [pvc closeDrawerAnimated:YES completion:^(BOOL finished) {
        printf("closed.\n");
        [self.cvc setPage:pages[indexPath.row]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
