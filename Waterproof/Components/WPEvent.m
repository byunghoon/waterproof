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
            event.name = [[data objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            event.date = [NSDate date];
            event.description = [[data objectForKey:@"Description"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            
            id links = [[data objectForKey:@"Links"] objectForKey:@"result"];
            if ([links isKindOfClass:[NSString class]] && ![links isEqualToString:@""]) {
                event.links = [NSArray arrayWithObject:(NSString *)links];
            } else if ([links isKindOfClass:[NSArray class]]) {
                event.links = (NSArray *)links;
            } else {
                event.links = [NSArray array];
            }
            
            break;
        }
        case DownloadTypeCalendarEvents: {
            event.eventID = [data objectForKey:@"ID"];
            event.eventType = EventTypeCalendar;
            event.name = [[data objectForKey:@"Title"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            event.description = [[data objectForKey:@"Description"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            event.venue = [data objectForKey:@"Where"];
            event.host = [data objectForKey:@"Host"];
            event.links = [NSArray arrayWithObject:[data objectForKey:@"Link"]];
            
            // Get Start Date
            NSString *eventPeriod = [data objectForKey:@"When"]; //Tue, 19 Jul 2011 13:00:00 -0500 - Tue, 19 Jul 2011 14:30:00 -0500
            NSRange dash = [eventPeriod rangeOfString:@" - "];
            if (dash.location != NSNotFound) {
                NSString *eventStart = [eventPeriod substringToIndex:dash.location];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"]; //Tue, 19 Jul 2011 13:00:00 -0500
                NSDate *eventDate = [[NSDate alloc] init];
                eventDate = [dateFormatter dateFromString:eventStart];
                event.date = eventDate;
            } else {
                event.date = [NSDate distantFuture];
            }
            
            break;
        }
        case DownloadTypeUniversityHolidays: {
            event.eventID = [data objectForKey:@"ID"];
            event.eventType = EventTypeHoliday;
            event.name = [[data objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            event.description = [[data objectForKey:@"Description"] stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            
            // Get Start Date
            NSString *holiday = [NSString stringWithFormat:@"%@ %@", [data objectForKey:@"Day"], [data objectForKey:@"Year"]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE MMMM dd yyyy"]; //Monday February 16 2012
            NSDate *date = [[NSDate alloc] init];
            date = [dateFormatter dateFromString:holiday];
            event.date = date;
            
            break;
        }
        default:
            break;
    }
    
    return event;
}

@end
