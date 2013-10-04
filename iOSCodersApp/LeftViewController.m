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
    Subject *subject;
    Apps *apps;
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
        subject = ((AppDelegate *)[UIApplication sharedApplication].delegate).subject;
        apps = ((AppDelegate *)[UIApplication sharedApplication].delegate).apps;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right)];}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return subject.list.count;
    return apps.list.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Subjects";
    }
    return @"Applets";
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
        cell.textLabel.text = subject.list[indexPath.row];
    } else {
        cell.textLabel.text = apps.list[indexPath.row];
    }
    cell.backgroundColor = self.view.backgroundColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    subject.curSubject = indexPath.row;
    MMDrawerController *pvc = (MMDrawerController *)self.parentViewController;
    [pvc closeDrawerAnimated:YES completion:^(BOOL finished) {
        printf("closed.\n");
        if (indexPath.section == 0) {
            [self.cvc setPage:SubjectPage];
        } else {
            [self.cvc setPage:AppPage];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
