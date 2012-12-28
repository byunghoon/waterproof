//
//  WPSearch.h
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 27..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPConnectionManager.h"

@interface WPSearch : NSObject

// universal
@property (nonatomic, strong) NSString *name;

// course search
@property (nonatomic, strong) NSString *deptAcronym;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;

// prof search
@property (nonatomic, strong) NSString *formalName;
@property (nonatomic, strong) NSString *rateMyProfID;
@property (nonatomic, strong) NSString *department;

// course schedule
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *credit;
@property (nonatomic, strong) NSString *campusLocation;
@property (nonatomic, strong) NSString *building;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *terms;

@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *location;

+ (WPSearch *)searchWithData:(id)data type:(DownloadType)downloadType;

@end
