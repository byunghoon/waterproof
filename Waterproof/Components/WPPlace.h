//
//  WPPlace.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WPConnectionManager.h"

typedef enum {
    PlaceTypeBuildings,
    PlaceTypeParking,
    PlaceTypeWatcardVendors
} PlaceType;

@interface WPPlace : NSObject

@property (nonatomic, strong) NSString *placeID;
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *imageURL;

// Buildings
@property (nonatomic, strong) NSString *acronym;


// Parking
@property (nonatomic, strong) NSString *maxCost;
@property (nonatomic, strong) NSString *weekendCost;
@property (nonatomic, strong) NSString *after4Cost;
@property (nonatomic, strong) NSString *hourlyCost;

// Watcard Vendors
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *phoneNumber;

+ (WPPlace *)placeWithData:(id)data type:(DownloadType)downloadType;


@end
