//
//  WPPlace.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPPlace.h"

@implementation WPPlace

+ (WPPlace *)placeWithData:(id)data type:(DownloadType)downloadType {
    WPPlace *place = [[WPPlace alloc] init];
    switch (downloadType) {
        case DownloadTypeBuildings: {
            place.placeID = [data objectForKey:@"ID"];
            place.placeType = PlaceTypeBuildings;
            place.name = [data objectForKey:@"Name"];
            place.acronym = [data objectForKey:@"Acronym"];
            place.imageURL = [data objectForKey:@"LargeThumb"];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[data objectForKey:@"Latitude"] floatValue] longitude:[[data objectForKey:@"Longitude"] floatValue]];
            place.geolocation = location;
            
            break;
        }
        case DownloadTypeParking: {
            NSString *lat = [data objectForKey:@"Latitude"];
            NSString *lon = [data objectForKey:@"Longitude"];
            place.placeID = [NSString stringWithFormat:@"%@,%@", lat, lon];
            
            place.placeType = PlaceTypeParking;
            place.name = [data objectForKey:@"Name"];
            place.paymentType = [data objectForKey:@"PaymentType"];
            place.after4Cost = [data objectForKey:@"After4Cost"];
            place.hourlyCost = [data objectForKey:@"HourlyCost"];
            place.maxCost = [data objectForKey:@"MaxCost"];
            place.weekendCost = [data objectForKey:@"WeekendCost"];
            
            NSString *parkingType = [data objectForKey:@"Type"];
            if ([parkingType isEqualToString:@"Visitor"]) {
                place.parkingType = ParkingTypeVisitor;
            } else if ([parkingType isEqualToString:@"FacultyAndStaff"]) {
                place.parkingType = ParkingTypeFacultyAndStaff;
            } else if ([parkingType isEqualToString:@"StudentPermit"]) {
                place.parkingType = ParkingTypeStudentPermit;
            } else if ([parkingType isEqualToString:@"Resident"]) {
                place.parkingType = ParkingTypeResident;
            } else if ([parkingType isEqualToString:@"ShortTerm"]) {
                place.parkingType = ParkingTypeShortTerm;
            } else if ([parkingType isEqualToString:@"Meter"]) {
                place.parkingType = ParkingTypeMeter;
            } else {
                place.parkingType = ParkingTypeOther;
            }
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
            place.geolocation = location;
            
            break;
        }
        case DownloadTypeWatcardVendors: {
            NSString *latlong = [data objectForKey:@"LatLong"];
            place.placeID = latlong;
            
            place.placeType = PlaceTypeWatcardVendors;
            place.name = [data objectForKey:@"Name"];
            place.imageURL = [data objectForKey:@"Logo"];
            place.location = [data objectForKey:@"Location"];
            place.phoneNumber = [data objectForKey:@"Telephone"];
            
            NSRange commaPosition = [latlong rangeOfString:@","];
            NSString *lat = [latlong substringToIndex:commaPosition.location];
            NSString *lon = [latlong substringFromIndex:commaPosition.location+2];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
            place.geolocation = location;
            
            break;
        }
        default:
            break;
    }
    
    return place;
}

@end
