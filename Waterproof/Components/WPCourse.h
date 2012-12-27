//
//  WPCourse.h
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 27..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPConnectionManager.h"

@interface WPCourse : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *deptAcronym;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;

+ (WPCourse *)courseWithData:(id)data type:(DownloadType)downloadType;

@end
