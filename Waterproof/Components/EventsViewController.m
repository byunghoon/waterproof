//
//  EventViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-21.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "EventsViewController.h"
#import "Constants.h"
#import "WPEvent.h"
#import "EventDetailViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _eventsArray = [NSMutableArray array];
    
    activeConnections = 3;
    [[WPConnectionManager instance] download:DownloadTypeDailyEvents delegate:self];
    [[WPConnectionManager instance] download:DownloadTypeCalendarEvents delegate:self];
    [[WPConnectionManager instance] download:DownloadTypeUniversityHolidays delegate:self];
}


#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self defaultTableViewCell];
    
    WPEvent *event = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = event.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WPEvent *selectedEvent = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc] init];
    eventDetailViewController.selectedEvent = selectedEvent;
	[self.navigationController pushViewController:eventDetailViewController animated:YES];
}


#pragma mark - Helper

- (void)reloadTable {
    activeConnections --;
    if (activeConnections == 0) {
        //TODO: sort data using date
        
        [_tableViewHeaderString addObject:@"TODAY"];
        [_tableViewData addObject:_eventsArray];
        
        [_tableView reloadData];
        [_spinner stopAnimating];
    }
}

#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];
    
    if (downloadType == DownloadTypeDailyEvents) {
        for (NSDictionary *result in resultArray) {
            [_eventsArray addObject:[WPEvent eventWithData:result type:EventTypeDaily]];
        }
        [self reloadTable];
    } else if (downloadType == DownloadTypeCalendarEvents) {
        //Handle data
        for (NSDictionary *result in resultArray) {
            [_eventsArray addObject:[WPEvent eventWithData:result type:EventTypeCalendar]];
        }
        [self reloadTable];
    } else if (downloadType == DownloadTypeUniversityHolidays) {
        //Handle data
        for (NSDictionary *result in resultArray) {
            [_eventsArray addObject:[WPEvent eventWithData:result type:EventTypeHoliday]];
        }
        [self reloadTable];
    }
}

- (void)downloadFailed:(DownloadType)downloadType {
    [self reloadTable];
}

@end
