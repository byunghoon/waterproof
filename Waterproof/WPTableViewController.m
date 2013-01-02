//
//  WPDefaultTableViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPTableViewController.h"
#import "Constants.h"

#define TITLE_LABEL_HEIGHT 31.0

@interface WPTableViewController ()

@end

@implementation WPTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 20.0 + WP_MARGIN_M;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:_tableView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    _spinner.center = _tableView.center;
    [_spinner startAnimating];
    [self.view addSubview:_spinner];
    
    _tableViewData = [NSMutableArray array];
    _tableViewHeaderString = [NSMutableArray array];
    
    showChevron = NO;
}


#pragma mark - Helper

- (UITableViewCell *)defaultTableViewCell {
    static NSString *CELL_IDENTIFIER = @"DefaultCell";
    return [self tableViewCellWithIdentifier:CELL_IDENTIFIER height:DEFAULT_CELL_HEIGHT];
}

- (UITableViewCell *)customTableViewCellForHeight:(float)height {
    static NSString *CELL_IDENTIFIER = @"CustomCell";
    return [self tableViewCellWithIdentifier:CELL_IDENTIFIER height:height];
}

- (UITableViewCell *)tableViewCellWithIdentifier:(NSString *)identifier height:(float)height {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, WP_MARGIN_S, cell.frame.size.width, height-WP_MARGIN_S)];
        cellView.backgroundColor = [UIColor whiteColor];
        
        if (showChevron) {
            UIImageView *chevronImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_chevron"]];
            chevronImageView.frame = CGRectMake(cellView.frame.size.width - 30, (height-15)/2, 15.0, 15.0);
            [cellView addSubview:chevronImageView];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, cellView.frame.size.width-50, TITLE_LABEL_HEIGHT)];
        titleLabel.font = [UIFont fontWithName:WP_FONT_CONTENT size:20.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = TAG_CELL_LABEL_TITLE;
        [cellView addSubview:titleLabel];
        
        int maxY = CGRectGetMaxY(titleLabel.frame);
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, maxY, titleLabel.frame.size.width, height-maxY-7)];
        detailLabel.font = [UIFont fontWithName:WP_FONT_CONTENT size:13.0f];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.numberOfLines = 2;
        detailLabel.lineBreakMode = kLabelTruncationTail;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.tag = TAG_CELL_LABEL_DETAIL;
        [cellView addSubview:detailLabel];
        
        [cell addSubview:cellView];
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        cell.selectedBackgroundView = selectedBackgroundView;
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableView.sectionHeaderHeight)];
    headerView.backgroundColor = WP_YELLOW;
    
    UIView *headerTopMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, WP_MARGIN_M)];
    headerTopMarginView.backgroundColor = self.view.backgroundColor;
    [headerView addSubview:headerTopMarginView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4+WP_MARGIN_M, self.view.frame.size.width-20, _tableView.sectionHeaderHeight-4-WP_MARGIN_M)];
    label.text = [_tableViewHeaderString objectAtIndex:section];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:WP_FONT_TITLE size:14.0f];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

@end
