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
    IndexObj *indexObj;
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
        indexObj = ((AppDelegate *)[UIApplication sharedApplication].delegate).indexObj;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];
}

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

- (NSString *)indexPathToString:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"section: %d, row: %d", indexPath.section, indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMDrawerController *pvc = (MMDrawerController *)self.parentViewController;
    [pvc closeDrawerAnimated:YES completion:^(BOOL finished) {
        printf("closed.\n");
        if (indexPath.section == 0) {
            [self.cvc setPage:pages[indexPath.row]];
        } else if (indexPath.section == 1) {
            [self.cvc runApp:apps[indexPath.row]];
        } else if (indexPath.section == 2) {
            [indexObj update];
            [indexObj cacheIndex];
            [tableView reloadData];
            [self.cvc setPage:pages[0]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
