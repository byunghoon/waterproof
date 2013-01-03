//
//  WPGroupedTableViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 13-01-02.
//  Copyright (c) 2013 Kokkiri. All rights reserved.
//

#import "WPGroupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

#define TAG_CELL_CONTAINER_VIEW 301
#define TAG_CELL_LABEL_GROUPED  302
#define TAG_CELL_LINK_GROUPED   303
#define GROUPED_CELL_MARGIN     10.0
#define GROUPED_CELL_WIDTH      300.0
#define GROUPED_LABEL_WIDTH     280.0
#define DEFAULT_CELL_FONT       [UIFont fontWithName:WP_FONT_CONTENT size:14.0f]
#define DEFAULT_LINK_FONT       [UIFont fontWithName:WP_FONT_CONTENT size:12.0f]

@interface WPGroupViewController ()

@end

@implementation WPGroupViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, WP_MARGIN_L)];
    headerView.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    _tableView.sectionHeaderHeight = 25.0;
    _tableView.sectionFooterHeight = WP_MARGIN_L;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    
    [self.view addSubview:_tableView];
    
    _tableViewHeaderString = [NSMutableArray array];
    _tableViewData = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    // filter empty or nil elements and convert to arrays
    for (int i=0; i<[_rawData count]; i++) {
        NSString *header = [_rawHeaders objectAtIndex:i];
        id data = [_rawData objectAtIndex:i];
        if (data) {
            if ([data isKindOfClass:[NSArray class]]) {
                if ([(NSArray *)data count] > 0) {
                    [_tableViewHeaderString addObject:header];
                    [_tableViewData addObject:data];
                }
            } else if ([data isKindOfClass:[NSDate class]]) {
                [_tableViewHeaderString addObject:header];
                [_tableViewData addObject:[NSArray arrayWithObject:[dateFormatter stringFromDate:data]]];
            } else if([data isKindOfClass:[NSString class]]) {
                [_tableViewHeaderString addObject:header];
                [_tableViewData addObject:[NSArray arrayWithObject:data]];
            }
        }
    }
    
    [_tableView reloadData];
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableViewData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_tableViewData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *header = [_tableViewHeaderString objectAtIndex:indexPath.section];
    NSString *text = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // Dynamically adjusting cell height
    CGSize constraintSize = CGSizeMake(GROUPED_LABEL_WIDTH, MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:([header isEqualToString:@"Links"] ? DEFAULT_LINK_FONT : DEFAULT_CELL_FONT)
                        constrainedToSize:constraintSize
                            lineBreakMode:kLabelLineBreakWordWrap];
    return labelSize.height + (2*WP_MARGIN_M) + ([header isEqualToString:@"Links"] ? WP_MARGIN_M : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"GroupedCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(GROUPED_CELL_MARGIN, WP_MARGIN_S, GROUPED_CELL_WIDTH, MAXFLOAT)];
        cellView.backgroundColor = [UIColor whiteColor];
        cellView.tag = TAG_CELL_CONTAINER_VIEW;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(GROUPED_CELL_MARGIN, WP_MARGIN_M, GROUPED_LABEL_WIDTH, MAXFLOAT)];
        textLabel.numberOfLines = 0;
        textLabel.font = DEFAULT_CELL_FONT;
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = TAG_CELL_LABEL_GROUPED;
        [cellView addSubview:textLabel];
        
        UITextView *linkTextView = [[UITextView alloc] initWithFrame:CGRectMake(GROUPED_CELL_MARGIN, WP_MARGIN_M, GROUPED_LABEL_WIDTH, MAXFLOAT)];
        linkTextView.editable = NO;
        linkTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        linkTextView.font = DEFAULT_LINK_FONT;
        linkTextView.textColor = [UIColor blackColor];
        linkTextView.backgroundColor = [UIColor clearColor];
        linkTextView.tag = TAG_CELL_LINK_GROUPED;
        [cellView addSubview:linkTextView];
        
        [cell addSubview:cellView];
    }
    
    // Dynamically adjusting cell height
    UIView *cellView = [cell viewWithTag:TAG_CELL_CONTAINER_VIEW];
    NSString *header = [_tableViewHeaderString objectAtIndex:indexPath.section];
    
    if ([header isEqualToString:@"Links"]) { // Recognize Links
        UITextView *linkView = (UITextView *)[cell viewWithTag:TAG_CELL_LINK_GROUPED];
        linkView.text = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        CGSize constraintSize = CGSizeMake(GROUPED_LABEL_WIDTH, MAXFLOAT);
        CGSize labelSize = [[linkView text] sizeWithFont:DEFAULT_LINK_FONT
                                        constrainedToSize:constraintSize
                                            lineBreakMode:kLabelLineBreakWordWrap];
        
        linkView.frame = CGRectMake(0, 0, GROUPED_CELL_WIDTH, labelSize.height+WP_MARGIN_M);
        cellView.frame = CGRectMake(GROUPED_CELL_MARGIN, WP_MARGIN_S, GROUPED_CELL_WIDTH, labelSize.height+(3*WP_MARGIN_M));
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, labelSize.height+(3*WP_MARGIN_M));
        
    } else {
        UILabel *textLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_GROUPED];
        textLabel.text = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        CGSize constraintSize = CGSizeMake(GROUPED_LABEL_WIDTH, MAXFLOAT);
        CGSize labelSize = [[textLabel text] sizeWithFont:DEFAULT_CELL_FONT
                                        constrainedToSize:constraintSize
                                            lineBreakMode:kLabelLineBreakWordWrap];
        
        textLabel.frame = CGRectMake(GROUPED_CELL_MARGIN, WP_MARGIN_M, GROUPED_LABEL_WIDTH, labelSize.height);
        cellView.frame = CGRectMake(GROUPED_CELL_MARGIN, WP_MARGIN_S, GROUPED_CELL_WIDTH, labelSize.height+(2*WP_MARGIN_M));
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, labelSize.height+(2*WP_MARGIN_M));
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableView.sectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(GROUPED_CELL_MARGIN, 0, GROUPED_CELL_WIDTH, _tableView.sectionHeaderHeight)];
    headerBackgroundView.backgroundColor = WP_YELLOW;
    [headerView addSubview:headerBackgroundView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*GROUPED_CELL_MARGIN, 0, GROUPED_LABEL_WIDTH, _tableView.sectionHeaderHeight)];
    label.text = [_tableViewHeaderString objectAtIndex:section];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:WP_FONT_TITLE size:14.0f];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableView.sectionFooterHeight)];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
}

@end
