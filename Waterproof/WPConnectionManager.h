//
//  WPConnectionManager.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DownloadType
} DownloadType;

@interface WPConnectionManager : NSObject

+ (id)instance;

@end
