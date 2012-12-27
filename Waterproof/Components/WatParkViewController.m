//
//  WatParkViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WatParkViewController.h"
#import "Constants.h"

#define TAG_LOT_LABEL 101
#define TAG_PERCENTAGE_VIEW 102
#define TAG_LAST_UPDATED_LABEL 103
#define TAG_OUT_OF_LABEL 104

@interface WatParkViewController ()

@end

@implementation WatParkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.bounces = NO;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    [[WPConnectionManager instance] download:DownloadTypeWatPark delegate:self];
    [self setDownloadInProgress:YES];
    _tableView.sectionHeaderHeight = 0.0;
}


#pragma mark - Helper

- (void)refreshTableView {
    if (!downloadInProgress) {
        [[WPConnectionManager instance] download:DownloadTypeWatPark delegate:self];
        downloadInProgress = YES;
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)setDownloadInProgress:(BOOL)value {
    downloadInProgress = value;
    [self.navigationItem.rightBarButtonItem setEnabled:!value];
    if (value) {
        [_spinner startAnimating];
    } else {
        [_spinner stopAnimating];
    }
    
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableViewData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _tableView.sectionHeaderHeight = 0.0;
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"WatParkCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int lotLabelSize = self.view.frame.size.height / [_tableViewData count] - (2*WP_MARGIN_M);
        UILabel *lotLabel = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, WP_MARGIN_M, lotLabelSize, lotLabelSize)];
        lotLabel.backgroundColor = [UIColor clearColor];
        lotLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:lotLabelSize*0.8];
        lotLabel.tag = TAG_LOT_LABEL;
        [cell addSubview:lotLabel];
        
        int maxX = CGRectGetMaxX(lotLabel.frame)+WP_MARGIN_L;
        int percentageViewHeight = 30;
        UIView *percentageView = [[UIView alloc] initWithFrame:CGRectMake(maxX, (cellHeight-percentageViewHeight)/2, self.view.frame.size.width-maxX-WP_MARGIN_M, percentageViewHeight)];
        percentageView.backgroundColor = WP_YELLOW;
        percentageView.tag = TAG_PERCENTAGE_VIEW;
        [cell addSubview:percentageView];
        
        UIView *fullGaugeView = [[UIView alloc] initWithFrame:CGRectMake(maxX, CGRectGetMaxY(percentageView.frame), self.view.frame.size.width-maxX-WP_MARGIN_M, 2)];
        fullGaugeView.backgroundColor = [UIColor grayColor];
        [cell addSubview:fullGaugeView];
        
        int smallLabelWidth = 120;
        int smallLabelHeight = 15;
        
        UILabel *lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-smallLabelWidth-WP_MARGIN_M, WP_MARGIN_M, smallLabelWidth, smallLabelHeight)];
        lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        lastUpdatedLabel.textAlignment = kLabelAlignmentRight;
        lastUpdatedLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:smallLabelHeight*0.8];
        lastUpdatedLabel.tag = TAG_LAST_UPDATED_LABEL;
        [cell addSubview:lastUpdatedLabel];
        
        UILabel *outOfLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-smallLabelWidth-WP_MARGIN_M, cellHeight-smallLabelHeight-WP_MARGIN_M, smallLabelWidth, smallLabelHeight)];
        outOfLabel.backgroundColor = [UIColor clearColor];
        outOfLabel.textAlignment = kLabelAlignmentRight;
        outOfLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:smallLabelHeight*0.8];
        outOfLabel.tag = TAG_OUT_OF_LABEL;
        [cell addSubview:outOfLabel];
    }
    
    NSDictionary *data = [_tableViewData objectAtIndex:indexPath.row];
    UILabel *lotLabel = (UILabel *)[cell viewWithTag:TAG_LOT_LABEL];
    UIView *percentageView = [cell viewWithTag:TAG_PERCENTAGE_VIEW];
    UILabel *lastUpdatedLabel = (UILabel *)[cell viewWithTag:TAG_LAST_UPDATED_LABEL];
    UILabel *outOfLabel = (UILabel *)[cell viewWithTag:TAG_OUT_OF_LABEL];
    
    // Lot Label
    lotLabel.text = [data objectForKey:@"LotName"];
    
    // Percentage View
    int percentageFullWidth = self.view.frame.size.width - CGRectGetMaxX(lotLabel.frame) - WP_MARGIN_M;
    int newWidth = percentageFullWidth * [[data objectForKey:@"PercentFilled"] intValue] / 100;
    percentageView.frame = CGRectMake(percentageView.frame.origin.x, percentageView.frame.origin.y, 0, percentageView.frame.size.height);
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        percentageView.frame = CGRectMake(percentageView.frame.origin.x, percentageView.frame.origin.y, newWidth, percentageView.frame.size.height);
    } completion:^(BOOL finished) {
        
        // Last Updated Label
        NSString *dateString = [data objectForKey:@"TimePolled"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //2012-02-10 17:12:24
        NSDate *dateFrom = [NSDate date];
        dateFrom = [dateFormatter dateFromString:dateString];
        
        NSDate *dateTo = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:dateFrom
                                                     toDate:dateTo
                                                    options:0];

        lastUpdatedLabel.text = [NSString stringWithFormat:@"%i mins ago", components.minute];
        
        
        // Out Of Label
        outOfLabel.text = [NSString stringWithFormat:@"vacancy: %@/%@", [data objectForKey:@"LatestCount"], [data objectForKey:@"Capacity"]];
    }];
    
    
    
    
    return cell;
}

#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];
    _tableViewData = [NSMutableArray arrayWithArray:resultArray];
    
    cellHeight = self.view.frame.size.height / [_tableViewData count];
    
    [_tableView reloadData];
    [self setDownloadInProgress:NO];
}

- (void)downloadFailed:(DownloadType)downloadType {
    [self setDownloadInProgress:YES];
}

@end
