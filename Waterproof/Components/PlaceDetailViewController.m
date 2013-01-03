//
//  PlaceDetailViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "Constants.h"

@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Info", @"Map", nil]];
    segmentedControl.frame = CGRectMake(MARGIN_GROUP_CELL, MARGIN_GROUP_CELL, WIDTH_CELL, 30);
    [segmentedControl addTarget:self action:@selector(segmentChanged) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl setDividerImage:[UIImage imageNamed:@"segcon_divider"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setDividerImage:[UIImage imageNamed:@"segcon_divider"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"segcon_yellow"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"segcon_white"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:WP_FONT_TITLE size:20.0f], UITextAttributeFont,
                                              [UIColor blackColor], UITextAttributeTextColor,
                                              nil] forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:WP_FONT_TITLE size:20.0f], UITextAttributeFont,
                                              [UIColor blackColor], UITextAttributeTextColor,
                                              nil] forState:UIControlStateNormal];
    
    [self.view addSubview:segmentedControl];
    
    int maxY = CGRectGetMaxY(segmentedControl.frame)+WP_MARGIN_M;
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, maxY, _tableView.frame.size.width, _tableView.frame.size.height-maxY);
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.google.ca/maps?q=%f,%f", _place.geolocation.coordinate.latitude, _place.geolocation.coordinate.longitude];
    _mapView = [[UIWebView alloc] initWithFrame:_tableView.frame];
    [_mapView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.view addSubview:_mapView];
    _mapView.hidden = YES;
}

- (void)segmentChanged {
    if (segmentedControl.selectedSegmentIndex == 0) {
        _tableView.hidden = NO;
        _mapView.hidden = YES;
    } else {
        _tableView.hidden = YES;
        _mapView.hidden = NO;
    }
}

@end