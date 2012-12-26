//
//  WPConnectionManager.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPConnectionManager.h"
#import "AFJSONRequestOperation.h"

static NSString *BASE_URL = @"http://api.uwaterloo.ca/public/v1/?key=13d92fbc5c34ebeeea1daca01bac2f8e&service=";

@implementation WPConnectionManager

+ (id)instance {
    static WPConnectionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)download:(DownloadType)downloadType delegate:(id<DownloadDelegate>)delegate {
    NSString *urlString;
    switch (downloadType) {
        case DownloadTypeDailyEvents: {
            urlString = [BASE_URL stringByAppendingString:@"Events"];
            break;
        }
        case DownloadTypeCalendarEvents: {
            urlString = [BASE_URL stringByAppendingString:@"CalendarEvents"];
            break;
        }
        case DownloadTypeUniversityHolidays: {
            urlString = [BASE_URL stringByAppendingString:@"Holidays"];
            break;
        }
            
        case DownloadTypeBuildings: {
            urlString = [BASE_URL stringByAppendingString:@"Buildings"];
            break;
        }
        case DownloadTypeParking: {
            urlString = [BASE_URL stringByAppendingString:@"ParkingList"];
            break;
        }
        case DownloadTypeWatcardVendors: {
            urlString = [BASE_URL stringByAppendingString:@"WatcardVendors"];
            break;
        }
        default:
            break;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [delegate downloadSucceeded:downloadType data:JSON];
    } failure:^(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON) {
        [delegate downloadFailed:downloadType];
    }];
    
    [operation start];
}

@end
