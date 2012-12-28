//
//  WPCourse.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 27..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "WPCourse.h"
#import "WPConnectionManager.h"

@implementation WPCourse

+ (WPCourse *)courseWithData:(id)data type:(DownloadType)downloadType {
    WPCourse *course = [[WPCourse alloc] init];
    switch (downloadType) {
        case DownloadTypeCourseSearch: {
            course.name = [[[data objectForKey:@"DeptAcronym"] stringByAppendingString:@" "] stringByAppendingString:[data objectForKey:@"Number"]];
            course.title = [data objectForKey:@"Title"];
            course.deptAcronym = [data objectForKey:@"DeptAcronym"];
            course.number = [data objectForKey:@"Number"];
            course.description = [data objectForKey:@"Description"];
            break;
        }
        default:
            break;
    }
    
    return course;
}

@end
