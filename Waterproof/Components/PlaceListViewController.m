//
//  PlaceListViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "PlaceListViewController.h"

@interface PlaceListViewController ()

@end

@implementation PlaceListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_downloadType) {
        case DownloadTypeBuildings:
            [[WPConnectionManager instance] download:DownloadTypeBuildings delegate:self];
            break;
        case DownloadTypeParking:
            [[WPConnectionManager instance] download:DownloadTypeParking delegate:self];
            break;
        case DownloadTypeWatcardVendors:
            [[WPConnectionManager instance] download:DownloadTypeWatcardVendors delegate:self];
            break;
        default:
            break;
    }
}


#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self defaultTableViewCell];
    
    WPPlace *place = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = place.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];
    NSMutableArray *placesArray = [NSMutableArray array];
    
    for (int i=0; i<[resultArray count]; i++) {
        WPPlace *place = [WPPlace placeWithData:[resultArray objectAtIndex:i] type:downloadType];
        [placesArray addObject:place];
    }
    
    [_tableViewData addObject:placesArray];
    [_tableViewHeaderString addObject:@"TODO: SORT LIST BY LOCATION"];
    [_tableView reloadData];
    [_spinner stopAnimating];
}

- (void)downloadFailed:(DownloadType)downloadType {
    //TODO: handle failure
}

@end
