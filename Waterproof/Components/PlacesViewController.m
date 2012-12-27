//
//  PlacesViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "PlacesViewController.h"
#import "Constants.h"
#import "WPPlace.h"
#import "PlaceListViewController.h"
#import "WatParkViewController.h"

@interface PlacesViewController ()

@end

@implementation PlacesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *logoView;
    if (IS_FOUR_INCH) {
        logoView = [[UIView alloc] initWithFrame:CGRectMake(0, WP_MARGIN_M, self.view.frame.size.width, 55.5)];
        logoView.backgroundColor = WP_YELLOW;
        [self.view addSubview:logoView];
        
        UIView *bottomMarginView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-WP_MARGIN_M-55.5, self.view.frame.size.width, 55.5)];
        bottomMarginView.backgroundColor = WP_YELLOW;
        [self.view addSubview:bottomMarginView];
    } else {
        logoView = [[UIView alloc] initWithFrame:CGRectMake(0, WP_MARGIN_M, self.view.frame.size.width, 29.0)];
        logoView.backgroundColor = WP_YELLOW;
        [self.view addSubview:logoView];
    }
    
    UIButton *buildingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buildingsButton.frame = CGRectMake(0, CGRectGetMaxY(logoView.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    buildingsButton.backgroundColor = WP_YELLOW;
    [buildingsButton setTitle:@"Buildings" forState:UIControlStateNormal];
    [buildingsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buildingsButton addTarget:self action:@selector(buildingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buildingsButton];
    
    UIButton *parkingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    parkingButton.frame = CGRectMake(self.view.frame.size.width-BUTTON_SIZE, CGRectGetMaxY(logoView.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    parkingButton.backgroundColor = WP_YELLOW;
    [parkingButton setTitle:@"Parking" forState:UIControlStateNormal];
    [parkingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [parkingButton addTarget:self action:@selector(parkingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:parkingButton];
    
    UIButton *watparkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    watparkButton.frame = CGRectMake(0, CGRectGetMaxY(buildingsButton.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    watparkButton.backgroundColor = WP_YELLOW;
    [watparkButton setTitle:@"WatPark" forState:UIControlStateNormal];
    [watparkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [watparkButton addTarget:self action:@selector(watparkButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:watparkButton];
    
    UIButton *vendersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    vendersButton.frame = CGRectMake(self.view.frame.size.width-BUTTON_SIZE, CGRectGetMaxY(buildingsButton.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    vendersButton.backgroundColor = WP_YELLOW;
    [vendersButton setTitle:@"Watcard Vendors" forState:UIControlStateNormal];
    [vendersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [vendersButton addTarget:self action:@selector(vendorsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vendersButton];
}

- (void)buildingsButtonPressed {
    PlaceListViewController *placeListViewController = [[PlaceListViewController alloc] init];
    placeListViewController.downloadType = DownloadTypeBuildings;
    [self.navigationController pushViewController:placeListViewController animated:YES];
}

- (void)parkingButtonPressed {
    PlaceListViewController *placeListViewController = [[PlaceListViewController alloc] init];
    placeListViewController.downloadType = DownloadTypeParking;
    [self.navigationController pushViewController:placeListViewController animated:YES];
}

- (void)watparkButtonPressed {
    WatParkViewController *watParkViewController = [[WatParkViewController alloc ] init];
    [self.navigationController pushViewController:watParkViewController animated:YES];
}

- (void)vendorsButtonPressed {
    PlaceListViewController *placeListViewController = [[PlaceListViewController alloc] init];
    placeListViewController.downloadType = DownloadTypeWatcardVendors;
    [self.navigationController pushViewController:placeListViewController animated:YES];
}

@end
