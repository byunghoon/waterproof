//
//  WPDefaultTableViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPTableViewController.h"
#import "Constants.h"

@interface WPTableViewController ()

@end

@implementation WPTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 20.0;
    
    [self.view addSubview:_tableView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    _spinner.center = _tableView.center;
    [_spinner startAnimating];
    [self.view addSubview:_spinner];
    
    _tableViewData = [NSMutableArray array];
    _tableViewHeaderString = [NSMutableArray array];
}


#pragma mark - Helper

- (UITableViewCell *)defaultTableViewCell {
    static NSString *CELL_IDENTIFIER = @"DefaultCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    return cell;
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableViewData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_tableViewData objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableView.sectionHeaderHeight)];
    label.text = [_tableViewHeaderString objectAtIndex:section];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:label.frame];
    headerView.backgroundColor = WP_YELLOW;
    [headerView addSubview:label];
    
    return headerView;
}

@end
