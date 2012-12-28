//
//  WPSearch.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 27..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "WPSearch.h"
#import "WPConnectionManager.h"

@implementation WPSearch

+ (WPSearch *)searchWithData:(id)data type:(DownloadType)downloadType {
    WPSearch *search = [[WPSearch alloc] init];
    switch (downloadType) {
        case DownloadTypeCourseSearch: {
            search.name = [[[data objectForKey:@"DeptAcronym"] stringByAppendingString:@" "] stringByAppendingString:[data objectForKey:@"Number"]];
            search.title = [data objectForKey:@"Title"];
            search.deptAcronym = [data objectForKey:@"DeptAcronym"];
            search.number = [data objectForKey:@"Number"];
            search.description = [data objectForKey:@"Description"];
            break;
        }
        case DownloadTypeProfessorSearch: {
            search.name = [data objectForKey:@"Name"];
            search.formalName = [data objectForKey:@"FormalName"];
            search.rateMyProfID = [data objectForKey:@"ID"];
            search.department = [data objectForKey:@"Department"];
            break;
        }
        case DownloadTypeCourseSchedule: {
            search.name = [[[data objectForKey:@"Subject"] stringByAppendingString:@" "] stringByAppendingString:[data objectForKey:@"Number"]];
            search.ID = [data objectForKey:@"ID"];
            search.credit = [data objectForKey:@"Credits"];
            search.campusLocation = [data objectForKey:@"CampusLocation"];
            search.building = [data objectForKey:@"Building"];
            search.room = [data objectForKey:@"Room"];
            search.days = [data objectForKey:@"Days"];
            search.startTime = [data objectForKey:@"StartTime"];
            search.endTime = [data objectForKey:@"endTime"];
            search.terms = [data objectForKey:@"Term"];
            break;
        }
        case DownloadTypeExamSchedule: {
            search.name = [[[data objectForKey:@"Course"] stringByAppendingString:@" - "] stringByAppendingString:[data objectForKey:@"Section"]];
            search.ID = [data objectForKey:@"ID"];
            search.section = [data objectForKey:@"Section"];
            search.day = [data objectForKey:@"Day"];
            search.date = [data objectForKey:@"Date"];
            search.startTime = [data objectForKey:@"Start"];
            search.endTime = [data objectForKey:@"end"];
            search.location = [data objectForKey:@"Location"];
            break;
        }
        default:
            break;
    }
    
    return search;
}

@end
