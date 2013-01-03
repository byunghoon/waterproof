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
#define TAG_CELL_TEXT_LABEL     302
#define TAG_CELL_SPECIAL_VIEW   303
#define TAG_CELL_CHEVRON        304
#define FONT_DEFAULT_TEXT       [UIFont fontWithName:WP_FONT_CONTENT size:14.0f]
#define FONT_SPECIAL_VIEW       [UIFont fontWithName:WP_FONT_CONTENT size:12.0f]

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
    
    showChevron = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _tableViewHeaderString = [NSMutableArray array];
    _tableViewData = [NSMutableArray array];
    _specialDataFlag = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
    
    // filter empty or nil elements and convert to arrays
    for (int i=0; i<[_rawData count]; i++) {
        NSString *header = [_rawHeaders objectAtIndex:i];
        id data = [_rawData objectAtIndex:i];
        if (data) {
            if ([data isKindOfClass:[NSArray class]]) {
                if ([(NSArray *)data count] > 0) {
                    [self insertHeaderString:header];
                    [_tableViewData addObject:data];
                }
            } else if ([data isKindOfClass:[NSDate class]]) {
                [self insertHeaderString:header];
                [_tableViewData addObject:[NSArray arrayWithObject:[dateFormatter stringFromDate:data]]];
            } else if([data isKindOfClass:[NSString class]]) {
                [self insertHeaderString:header];
                [_tableViewData addObject:[NSArray arrayWithObject:data]];
            }
        }
    }
    
    if ([_showChevronFlag count] > 0) {
        showChevron = YES;
    }
    
    [_tableView reloadData];
}


#pragma mark - Helper

- (void)insertHeaderString:(NSString *)header {
    [_tableViewHeaderString addObject:header];
    if ([header isEqualToString:@"Links"]) {
        [_specialDataFlag addObject:[NSNumber numberWithInteger:UIDataDetectorTypeLink]];
    } else if([header isEqualToString:@"Phone Number"]){
        [_specialDataFlag addObject:[NSNumber numberWithInteger:UIDataDetectorTypePhoneNumber]];
    } else {
        [_specialDataFlag addObject:[NSNumber numberWithInteger:UIDataDetectorTypeNone]];
    }
}


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_tableViewData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_tableViewData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isSpecial = [[_specialDataFlag objectAtIndex:indexPath.section] unsignedIntegerValue] != UIDataDetectorTypeNone;
    NSString *text = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // Dynamically adjusting cell height
    CGSize constraintSize = CGSizeMake(WIDTH_LABEL, MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:(isSpecial ? FONT_SPECIAL_VIEW : FONT_DEFAULT_TEXT)
                        constrainedToSize:constraintSize
                            lineBreakMode:kLabelLineBreakWordWrap];
    return labelSize.height + WP_MARGIN_S + (2*WP_MARGIN_M) + (isSpecial ? WP_MARGIN_M : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"GroupedCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_GROUP_CELL, WP_MARGIN_S, WIDTH_CELL, 0)];
        cellView.backgroundColor = [UIColor whiteColor];
        cellView.tag = TAG_CELL_CONTAINER_VIEW;
        
        if (showChevron) {
            UIImageView *chevronImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_chevron"]];
            chevronImageView.frame = CGRectMake(WIDTH_CELL-30, 0, 15.0, 15.0);
            chevronImageView.tag = TAG_CELL_CHEVRON;
            chevronImageView.hidden = YES;
            [cellView addSubview:chevronImageView];
        }
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_GROUP_CELL, WP_MARGIN_M, WIDTH_LABEL, 0)];
        textLabel.numberOfLines = 0;
        textLabel.font = FONT_DEFAULT_TEXT;
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = TAG_CELL_TEXT_LABEL;
        [cellView addSubview:textLabel];
        
        UITextView *specialView = [[UITextView alloc] initWithFrame:CGRectMake(MARGIN_GROUP_CELL, WP_MARGIN_M, WIDTH_LABEL, 0)];
        specialView.editable = NO;
        specialView.font = FONT_SPECIAL_VIEW;
        specialView.textColor = [UIColor blackColor];
        specialView.backgroundColor = [UIColor clearColor];
        specialView.tag = TAG_CELL_SPECIAL_VIEW;
        [cellView addSubview:specialView];
        
        [cell addSubview:cellView];
    }
    
    NSString *text = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    // Dynamically adjusting cell height
    UIDataDetectorTypes dataDetectorTypes = [[_specialDataFlag objectAtIndex:indexPath.section] unsignedIntegerValue];
    UIView *cellView = [cell viewWithTag:TAG_CELL_CONTAINER_VIEW];
    CGSize constraintSize = CGSizeMake(WIDTH_LABEL, MAXFLOAT);
    
    if (dataDetectorTypes != UIDataDetectorTypeNone) { // Links or phone numbers
        UITextView *textView = (UITextView *)[cell viewWithTag:TAG_CELL_SPECIAL_VIEW];
        textView.dataDetectorTypes = dataDetectorTypes;
        textView.text = text;
        
        CGSize labelSize = [text sizeWithFont:FONT_SPECIAL_VIEW
                            constrainedToSize:constraintSize
                                lineBreakMode:kLabelLineBreakWordWrap];
        
        textView.frame = CGRectMake(0, 0, WIDTH_CELL, labelSize.height+WP_MARGIN_M);
        cellView.frame = CGRectMake(MARGIN_GROUP_CELL, WP_MARGIN_S, WIDTH_CELL, labelSize.height+(3*WP_MARGIN_M));
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, labelSize.height+(3*WP_MARGIN_M));
    } else {
        UILabel *textLabel = (UILabel *)[cell viewWithTag:TAG_CELL_TEXT_LABEL];
        textLabel.text = text;
        
        CGSize labelSize = [text sizeWithFont:FONT_DEFAULT_TEXT
                            constrainedToSize:constraintSize
                                lineBreakMode:kLabelLineBreakWordWrap];
        
        textLabel.frame = CGRectMake(MARGIN_GROUP_CELL, WP_MARGIN_M, WIDTH_LABEL, labelSize.height);
        cellView.frame = CGRectMake(MARGIN_GROUP_CELL, WP_MARGIN_S, WIDTH_CELL, labelSize.height+(2*WP_MARGIN_M));
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, labelSize.height+(2*WP_MARGIN_M)+WP_MARGIN_S);
    }
    
    if ([[[_showChevronFlag objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] boolValue]) {
        UIImageView *chevronImageView = (UIImageView *)[cell viewWithTag:TAG_CELL_CHEVRON];
        chevronImageView.frame = CGRectMake(WIDTH_CELL-30, (cellView.frame.size.height-15.0)/2, 15.0, 15.0);
        chevronImageView.hidden = NO;
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectedBackgroundView;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _tableView.sectionHeaderHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *headerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_GROUP_CELL, 0, WIDTH_CELL, _tableView.sectionHeaderHeight)];
    headerBackgroundView.backgroundColor = WP_YELLOW;
    [headerView addSubview:headerBackgroundView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*MARGIN_GROUP_CELL, WP_MARGIN_S, WIDTH_LABEL, _tableView.sectionHeaderHeight-WP_MARGIN_S)];
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
