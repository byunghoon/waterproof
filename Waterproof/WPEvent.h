//
//  WPEvent.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-22.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPConnectionManager.h"

typedef enum {
    EventTypeDaily,
    EventTypeCalendar,
    EventTypeHoliday
} EventType;

@interface WPEvent : NSObject

@property (nonatomic, strong) NSString *eventID;
@property (nonatomic) EventType eventType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *venue;
@property (nonatomic, strong) NSString *host;

+ (WPEvent *)eventWithData:(id)data type:(DownloadType)downloadType;

@end
