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

#define CUSTOM_CELL_HEIGHT 88.0

@interface EventsViewController ()

@end

@implementation EventsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showChevron = YES;
    
    _dailyEventsArray = [NSMutableArray array];
    _dateSpecificEventsArray = [NSMutableArray array];
    
    activeConnections = 3;
    // Disabled for less server hit count
    [[WPConnectionManager instance] download:DownloadTypeDailyEvents delegate:self];
    [[WPConnectionManager instance] download:DownloadTypeCalendarEvents delegate:self];
    [[WPConnectionManager instance] download:DownloadTypeUniversityHolidays delegate:self];
}


#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableViewCellStyleDetailedForHeight:CUSTOM_CELL_HEIGHT];
    WPEvent *event = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_TITLE];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_DETAIL];
    
    titleLabel.text = event.name;
    titleLabel.font = [UIFont fontWithName:WP_FONT_CONTENT size:17.0f];
    
    if (event.eventType == EventTypeHoliday) {
        detailLabel.text = @"University holiday";
    } else {
        detailLabel.text = event.description;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CUSTOM_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPEvent *selectedEvent = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc] init];
    eventDetailViewController.selectedEvent = selectedEvent;
	[self.navigationController pushViewController:eventDetailViewController animated:YES];
}


#pragma mark - Helper

- (void)reloadTable {
    activeConnections --;
    if (activeConnections == 0) {
        // Set date format
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];
        
        // Add daily events first
        NSString *header = [dateFormatter stringFromDate:[NSDate date]];
        [_tableViewHeaderString addObject:header];
        [_tableViewData addObject:_dailyEventsArray];
        
        // Calendar events and university holidays
        // Sort using date
        NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        [_dateSpecificEventsArray sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
        
        // Categorize using date
        for (WPEvent *event in _dateSpecificEventsArray) {
            BOOL laterThanToday = [event.date compare:[NSDate date]] == NSOrderedDescending;
            BOOL earlierThanLimit = [event.date compare:[NSDate dateWithTimeIntervalSinceNow:86400*365]] == NSOrderedAscending;
            if (laterThanToday && earlierThanLimit) {
                NSString *header = [dateFormatter stringFromDate:event.date];
                if ([[_tableViewHeaderString lastObject] isEqualToString:header]) {
                    [[_tableViewData lastObject] addObject:event];
                } else {
                    [_tableViewHeaderString addObject:header];
                    [_tableViewData addObject:[NSMutableArray arrayWithObject:event]];
                }
            }
        }
        
        [_tableViewHeaderString replaceObjectAtIndex:0 withObject:@"TODAY"];
        [_tableView reloadData];
        [_spinner stopAnimating];
    }
}

#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];
    
    if (downloadType == DownloadTypeDailyEvents) {
        for (NSDictionary *result in resultArray) {
            [_dailyEventsArray addObject:[WPEvent eventWithData:result type:EventTypeDaily]];
        }
        [self reloadTable];
    } else if (downloadType == DownloadTypeCalendarEvents) {
        for (NSDictionary *result in resultArray) {
            WPEvent *calendarEvent = [WPEvent eventWithData:result type:EventTypeCalendar];
            [_dateSpecificEventsArray addObject:calendarEvent];
        }
        [self reloadTable];
    } else if (downloadType == DownloadTypeUniversityHolidays) {
        for (NSDictionary *resultByYear in resultArray) {
            NSString *yearString = [resultByYear objectForKey:@"Year"];
            NSArray *holidayArray = [[resultByYear objectForKey:@"Holidays"] objectForKey:@"result"];
            
            for (NSDictionary *resultByDay in holidayArray) {
                NSMutableDictionary *resultByDayMutable = [NSMutableDictionary dictionaryWithDictionary:resultByDay];
                [resultByDayMutable setObject:yearString forKey:@"Year"];
                
                NSArray *days = [[resultByDayMutable objectForKey:@"Day"] componentsSeparatedByString:@", "];
                for (NSString *day in days) {
                    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:resultByDayMutable];
                    
                    NSRange comma = [day rangeOfString:@","]; //"Day" sometimes has extra comma
                    if (comma.location == NSNotFound) {
                        [result setObject:day forKey:@"Day"];
                    } else {
                        [result setObject:[day substringToIndex:comma.location] forKey:@"Day"];
                    }
                    [_dateSpecificEventsArray addObject:[WPEvent eventWithData:result type:EventTypeHoliday]];
                }
            }
        }
        [self reloadTable];
    }
}

- (void)downloadFailed:(DownloadType)downloadType {
    [self reloadTable];
}

@end
