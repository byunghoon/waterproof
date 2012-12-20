//
//  WPConnectionManager.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPConnectionManager.h"

static NSString *WATERLOO_API_KEY = @"13d92fbc5c34ebeeea1daca01bac2f8e";

@implementation WPConnectionManager

+ (id)instance {
    static WPConnectionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
