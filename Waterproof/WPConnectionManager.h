//
//  WPConnectionManager.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DownloadTypeDailyEvents,
    DownloadTypeCalendarEvents,
    DownloadTypeUniversityHolidays,
    
    DownloadTypeCourseSearch,
    DownloadTypeCourseInfo,
    DownloadTypeCoursePrerequisites,
    DownloadTypeCourseSchedule,
    DownloadTypeExamSchedule,
    DownloadTypeProfessorSearch,
    
    DownloadTypeBuildings,
    DownloadTypeParking,
    DownloadTypeWatPark,
    DownloadTypeWatcardVendors
} DownloadType;


@protocol DownloadDelegate <NSObject>

@optional
- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data;
- (void)downloadFailed:(DownloadType)downloadType;

@end


@interface WPConnectionManager : NSObject

+ (id)instance;
- (void)download:(DownloadType)downloadType delegate:(id<DownloadDelegate>)delegate;
- (void)search:(DownloadType)downloadType delegate:(id<DownloadDelegate>)delegate query:(NSString*)query;

@end
