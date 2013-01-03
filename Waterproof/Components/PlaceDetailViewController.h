//
//  PlaceDetailViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPGroupViewController.h"
#import "WPPlace.h"

@interface PlaceDetailViewController : WPGroupViewController {
    UISegmentedControl *segmentedControl;
    UIWebView *_mapView;
}

@property (nonatomic, strong) WPPlace *place;

@end
