//
//  PlaceDetailViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

#define LABEL_HEIGHT 25

@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, WP_MARGIN_M, self.view.frame.size.width-(2*WP_MARGIN_M), LABEL_HEIGHT)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    float maxY = CGRectGetMaxY(titleLabel.frame);
    
    if (_place.placeType == PlaceTypeBuildings) {
        titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", _place.name, _place.acronym];
        
    } else if (_place.placeType == PlaceTypeParking) {
        titleLabel.text = [NSString stringWithFormat:@"Parking Lot %@", _place.name];
        maxY = [self drawParkingDetails];
        
    } else if (_place.placeType == PlaceTypeWatcardVendors) {
        titleLabel.text = _place.name;
        maxY = [self drawVendorDetails];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.google.ca/maps?q=%f,%f", _place.geolocation.coordinate.latitude, _place.geolocation.coordinate.longitude];
    UIWebView *mapView = [[UIWebView alloc] initWithFrame:CGRectMake(0, maxY+WP_MARGIN_L, self.view.frame.size.width, self.view.frame.size.height-(maxY+WP_MARGIN_L))];
    [mapView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.view addSubview:mapView];
}

- (float)drawParkingDetails {
    float cumulativeMaxY = LABEL_HEIGHT+(2*WP_MARGIN_M);
    
    // Parking and Payment Type
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, cumulativeMaxY, self.view.frame.size.width-(2*WP_MARGIN_M), LABEL_HEIGHT)];
    typeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:typeLabel];
    
    if (_place.parkingType == ParkingTypeVisitor) {
        if ([_place.paymentType isEqualToString:@"PayAndDisplay"]) {
            typeLabel.text = @"Visitor Parking - pay and display";
        } else {
            typeLabel.text = @"Visitor Parking - coin entry";
        }
    } else if (_place.parkingType == ParkingTypeStudentPermit) {
        typeLabel.text = @"Student Permit Parking";
    } else if (_place.parkingType == ParkingTypeFacultyAndStaff) {
        typeLabel.text = @"Faculty and Staff Only";
    } else if (_place.parkingType == ParkingTypeResident) {
        typeLabel.text = @"Resident Parking";
    }
    
    cumulativeMaxY = CGRectGetMaxY(typeLabel.frame);
    
    // Cost Information Label, only when parking type is visitor
    if (_place.parkingType == ParkingTypeVisitor) {
        UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, CGRectGetMaxY(typeLabel.frame)+WP_MARGIN_M, typeLabel.frame.size.width, LABEL_HEIGHT)];
        costLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:costLabel];
        
        BOOL hasHourlyCost = ![_place.hourlyCost isEqualToString:@""];
        BOOL hasMaxCost = ![_place.maxCost isEqualToString:@""];
        BOOL hasAfter4Cost = ![_place.after4Cost isEqualToString:@""];
        BOOL hasWeekendCost = ![_place.weekendCost isEqualToString:@""];
        
        if (hasHourlyCost && hasMaxCost) {
            costLabel.text = [NSString stringWithFormat:@"$%@ per hour up to $%@", _place.hourlyCost, _place.maxCost];
        } else if (hasMaxCost) {
            costLabel.text = [NSString stringWithFormat:@"Flat fee $%@", _place.maxCost];
        }
        
        cumulativeMaxY = CGRectGetMaxY(costLabel.frame);
        
        if (hasAfter4Cost || hasWeekendCost) {
            UILabel *costLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, CGRectGetMaxY(costLabel.frame)+WP_MARGIN_M, typeLabel.frame.size.width, LABEL_HEIGHT)];
            costLabel2.backgroundColor = [UIColor clearColor];
            [self.view addSubview:costLabel2];
            
            if (hasAfter4Cost && hasWeekendCost) {
                if ([_place.weekendCost isEqualToString:@"0"]) {
                    costLabel2.text = [NSString stringWithFormat:@"$%@ after 4pm, free on weekends", _place.after4Cost];
                } else {
                    costLabel2.text = [NSString stringWithFormat:@"$%@ after 4pm, $%@ on weekends", _place.after4Cost, _place.weekendCost];
                }
            }
            else if (hasAfter4Cost) {
                costLabel2.text = [NSString stringWithFormat:@"$%@ after 4pm", _place.after4Cost];
            }
            else if (hasWeekendCost) {
                if ([_place.weekendCost isEqualToString:@"0"]) {
                    costLabel2.text = @"free on weekends";
                } else {
                    costLabel2.text = [NSString stringWithFormat:@"$%@ on weekends", _place.weekendCost];
                }
            }
            
            cumulativeMaxY = CGRectGetMaxY(costLabel2.frame);
        }
        
        return cumulativeMaxY;
    }
    
    return CGRectGetMaxY(typeLabel.frame);
}

- (float)drawVendorDetails {
    float cumulativeMaxY = LABEL_HEIGHT+(2*WP_MARGIN_M);
    
    // Phone Number Label
    if (_place.phoneNumber) {
        UILabel *phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, cumulativeMaxY, self.view.frame.size.width-(2*WP_MARGIN_M), LABEL_HEIGHT)];
        phoneNumberLabel.backgroundColor = [UIColor clearColor];
        phoneNumberLabel.text = _place.phoneNumber;
        [self.view addSubview:phoneNumberLabel];
        cumulativeMaxY = (cumulativeMaxY > CGRectGetMaxY(phoneNumberLabel.frame)) ? cumulativeMaxY : CGRectGetMaxY(phoneNumberLabel.frame);
    }
    
    // Logo ImageView
    if (_place.imageURL) {
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-WP_MARGIN_M-70, WP_MARGIN_M, 70, 70)];
        [logoView setImageWithURL:[NSURL URLWithString:_place.imageURL]];
        [self.view addSubview:logoView];
        cumulativeMaxY = (cumulativeMaxY > CGRectGetMaxY(logoView.frame)) ? cumulativeMaxY : CGRectGetMaxY(logoView.frame);
    }
    
    return cumulativeMaxY;
}

@end