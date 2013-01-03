//
//  WPDatabaseManager.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 13-01-02.
//  Copyright (c) 2013 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DataTypePastCourses,
    DataTypeCurrentCourses
} DataType;

@interface WPDatabaseManager : NSObject {
    NSArray *currentCourses;
    NSArray *pastCourses;
}

+ (id)instance;
- (void)setCourseString:(NSString *)courses forType:(DataType)dataType;
- (NSString *)getCourseStringForType:(DataType)dataType;
- (NSArray *)getCourseArrayForType:(DataType)dataType;

@end
