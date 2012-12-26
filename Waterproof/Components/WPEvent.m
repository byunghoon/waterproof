//
//  WPEvent.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-22.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPEvent.h"

@implementation WPEvent

+ (WPEvent *)eventWithData:(id)data type:(DownloadType)downloadType {
    WPEvent *event = [[WPEvent alloc] init];
    switch (downloadType) {
        case DownloadTypeDailyEvents: {
            event.eventID = [data objectForKey:@"ID"];
            event.eventType = EventTypeDaily;
            event.name = [data objectForKey:@"Name"];
            event.date = [NSDate date];
            event.description = [data objectForKey:@"Description"];
            event.links = [[data objectForKey:@"Links"] objectForKey:@"result"];
            break;
        }
        case DownloadTypeCalendarEvents: {
            /*NSString *dateString = [data objectForKey:@"When"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //@"Tue, 19 Jul 2011 5:30 pm EDT - Tue, 19 Jul 2011 7:00 pm EDT"
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            */
            event.eventID = [data objectForKey:@"ID"];
            event.eventType = EventTypeCalendar;
            event.name = [data objectForKey:@"Title"];
            event.date = [NSDate distantFuture];
            event.description = [data objectForKey:@"Description"];
            event.venue = [data objectForKey:@"Where"];
            event.host = [data objectForKey:@"Host"];
            break;
        }
        case DownloadTypeUniversityHolidays: {
            event.eventID = [data objectForKey:@"ID"];
            event.eventType = EventTypeDaily;
            event.name = [data objectForKey:@"Name"];
            event.date = [NSDate date];
            event.description = [data objectForKey:@"Description"];
            break;
        }
        default:
            break;
    }
    
    return event;
}

@end
