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
            search.type = courseSearch;
            break;
        }
        case DownloadTypeProfessorSearch: {
            search.name = [[data objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
            search.formalName = [data objectForKey:@"FormalName"];
            search.rateMyProfID = [data objectForKey:@"ID"];
            search.department = [data objectForKey:@"Department"];
            search.type = profSearch;
            break;
        }
        case DownloadTypeCourseSchedule: {
            if ([data objectForKey:@"Location"] != @"WLU") {
                search.name = [[[[[data objectForKey:@"Subject"] stringByAppendingString:@" "] stringByAppendingString:[data objectForKey:@"Number"]] stringByAppendingString:@" - "] stringByAppendingString:[data objectForKey:@"Section"]];
            } else {
                search.name = [[[data objectForKey:@"Subject"] stringByAppendingString:@" "] stringByAppendingString:[data objectForKey:@"Number"]];
            }
            search.name2 = [[[data objectForKey:@"Subject"] stringByAppendingString:@" "] stringByAppendingString:[data objectForKey:@"Number"]];
            search.ID = [data objectForKey:@"ID"];
            search.credit = [data objectForKey:@"Credits"];
            search.campusLocation = [data objectForKey:@"CampusLocation"];
            search.building = [data objectForKey:@"Building"];
            search.room = [data objectForKey:@"Room"];
            search.days = [data objectForKey:@"Days"];
            search.startTime = [data objectForKey:@"StartTime"];
            search.endTime = [data objectForKey:@"EndTime"];
            search.terms = [data objectForKey:@"Term"];
            search.section = [data objectForKey:@"Section"];
            search.type = scheduleSearch;
            break;
        }
        case DownloadTypeExamSchedule: {
            search.name2 = [data objectForKey:@"Course"];
            search.ID = [data objectForKey:@"ID"];
            search.section = [data objectForKey:@"Section"];
            search.day = [data objectForKey:@"Day"];
            search.date = [data objectForKey:@"Date"];
            search.startTime = [data objectForKey:@"Start"];
            search.endTime = [data objectForKey:@"End"];
            search.location = [data objectForKey:@"Location"];
            if (search.section == @"") {
                NSLog(@"%@", search.section);
            }
            if (search.section == @"") {
                search.name = [data objectForKey:@"Course"];
            } else {
                search.name = [[[data objectForKey:@"Course"] stringByAppendingString:@" - "] stringByAppendingString:[data objectForKey:@"Section"]];
            }
            search.type = examSearch;
            break;
        }
        default:
            break;
    }
    
    return search;
}

@end
