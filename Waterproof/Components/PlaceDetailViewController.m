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
    UIWebView *mapView = [[UIWebView alloc] initWithFrame:CGRectMake(0, maxY+WP_MARGIN_M, self.view.frame.size.width, self.view.frame.size.height-(maxY+WP_MARGIN_M))];
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
        costLabel.text = _place.costInfo1;
        [self.view addSubview:costLabel];
        
        cumulativeMaxY = CGRectGetMaxY(costLabel.frame);
        
        if (_place.costInfo2) {
            UILabel *costLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_M, CGRectGetMaxY(costLabel.frame)+WP_MARGIN_M, typeLabel.frame.size.width, LABEL_HEIGHT)];
            costLabel2.backgroundColor = [UIColor clearColor];
            costLabel2.text = _place.costInfo2;
            [self.view addSubview:costLabel2];
            
            cumulativeMaxY = CGRectGetMaxY(costLabel2.frame);
        }
        
        return cumulativeMaxY;
    }
    
    return CGRectGetMaxY(typeLabel.frame);
}

- (float)drawVendorDetails {
    float cumulativeMaxY = LABEL_HEIGHT+(2*WP_MARGIN_M);
    
    // Phone Number TextView
    if (_place.phoneNumber) {
        UITextView *phoneNumberView = [[UITextView alloc] initWithFrame:CGRectMake(WP_MARGIN_M, cumulativeMaxY, self.view.frame.size.width-(2*WP_MARGIN_M), LABEL_HEIGHT)];
        phoneNumberView.text = _place.phoneNumber;
        phoneNumberView.backgroundColor = [UIColor clearColor];
        phoneNumberView.editable = NO;
        phoneNumberView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
        [self.view addSubview:phoneNumberView];
        cumulativeMaxY = (cumulativeMaxY > CGRectGetMaxY(phoneNumberView.frame)) ? cumulativeMaxY : CGRectGetMaxY(phoneNumberView.frame);
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