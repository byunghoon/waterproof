//
//  WPDatabaseManager.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 13-01-02.
//  Copyright (c) 2013 Kokkiri. All rights reserved.
//

#import "WPDatabaseManager.h"

@implementation WPDatabaseManager

+ (id)instance {
    static WPDatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance reloadData];
    });
    return sharedInstance;
}

- (void)setCourseString:(NSString *)courses forType:(DataType)dataType {
    [self writeCourseString:courses forType:dataType];
    [self reloadData];
}

- (NSString *)getCourseStringForType:(DataType)dataType {
    return [self readCourseStringForType:dataType];
}

- (NSArray *)getCourseArrayForType:(DataType)dataType {
    switch (dataType) {
        case DataTypePastCourses:
            return pastCourses;
        case DataTypeCurrentCourses:
            return currentCourses;
    }
}


#pragma mark - Private

- (void)reloadData {
    currentCourses = [self readCourseArrayForType:DataTypeCurrentCourses];
    pastCourses = [self readCourseArrayForType:DataTypePastCourses];
}

- (void)writeCourseString:(NSString *)courses forType:(DataType)dataType {
    [[NSUserDefaults standardUserDefaults] setObject:courses forKey:[self getKeyForType:dataType]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)readCourseStringForType:(DataType)dataType {
    NSString *courses = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:[self getKeyForType:dataType]];
    return courses;
}

- (NSArray *)readCourseArrayForType:(DataType)dataType {
    NSMutableArray *formattedArray = [NSMutableArray array];
    
    NSString *rawString = [self readCourseStringForType:dataType]; // @"AAA BBB, CCC DDD, EEE FFF"
    NSArray *rawArray = [rawString componentsSeparatedByString:@","];
    for (NSString *courseUntrimmed in rawArray) {
        NSString *courseFullString = [courseUntrimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (![courseFullString isEqualToString:@""]) { // @"AAA BBB"
            NSArray *courseSplitted = [courseFullString componentsSeparatedByString:@" "];
            
            if ([courseSplitted count] == 2 && [courseFullString isEqualToString:[NSString stringWithFormat:@"%@ %@", [courseSplitted objectAtIndex:0], [courseSplitted objectAtIndex:1]]]) { // @"AAA", @"BBB"
                
                NSString *subject = [courseSplitted objectAtIndex:0];
                NSString *number = [courseSplitted objectAtIndex:1];
                NSCharacterSet *alphabetSet = [NSCharacterSet letterCharacterSet];
                BOOL validSubject = [[subject stringByTrimmingCharactersInSet:alphabetSet] isEqualToString:@""];
                NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
                BOOL validNumber = [[number stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
                
                if (validSubject && validNumber) { // @"econ", @"101"
                    NSArray *keys = [NSArray arrayWithObjects:@"subject", @"number", nil];
                    NSArray *objects = [NSArray arrayWithObjects:[subject capitalizedString], number, nil]; // @"ECON", @"101"
                    NSDictionary *course = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                    [formattedArray addObject:course];
                }
            }
        }
    }
    
    return formattedArray;
}


#pragma mark - helper

- (NSString *)getKeyForType:(DataType)dataType {
    switch (dataType) {
        case DataTypePastCourses:
            return @"DataTypePastCourses";
        case DataTypeCurrentCourses:
            return @"DataTypeCurrentCourses";
        default:
            return nil;
    }
}

@end
