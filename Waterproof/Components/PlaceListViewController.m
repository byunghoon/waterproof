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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (_downloadType == DownloadTypeParking) {
        return nil;
    }
    return _tableViewHeaderString;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];
    NSMutableArray *placesArray = [NSMutableArray array];
    
    if (downloadType == DownloadTypeParking) { // Parking - sort by parking type
        _tableViewHeaderString = [NSArray arrayWithObjects:@"Visitor", @"Student Permit", @"Faculty and Staff", @"Resident", nil];
        
        // create arrays inside _tableViewData
        for (int i=0; i<[_tableViewHeaderString count]; i++) {
            [_tableViewData addObject:[NSMutableArray array]];
        }
        
        // insert place objects
        for (int i=0; i<[resultArray count]; i++) {
            WPPlace *place = [WPPlace placeWithData:[resultArray objectAtIndex:i] type:downloadType];
            if (place.name && place.parkingType) {
                if ([place.parkingType isEqualToString:@"Visitor"]) {
                    [[_tableViewData objectAtIndex:0] addObject:place];
                } else if ([place.parkingType isEqualToString:@"StudentPermit"]) {
                    [[_tableViewData objectAtIndex:1] addObject:place];
                } else if ([place.parkingType isEqualToString:@"FacultyAndStaff"]) {
                    [[_tableViewData objectAtIndex:2] addObject:place];
                } else if ([place.parkingType isEqualToString:@"Resident"]) {
                    [[_tableViewData objectAtIndex:3] addObject:place];
                }
            }
        }
        
    } else { // Buildings and Vendors - sort by alphabet (O(n)+O(54))
        static int MAX_INDEXES = 27; //# and a-z
        // create arrays inside placeArray
        for (int i=0; i<MAX_INDEXES; i++) {
            [placesArray addObject:[NSMutableArray array]];
        }
        
        // insert place objects into placeArray
        for (int i=0; i<[resultArray count]; i++) {
            WPPlace *place = [WPPlace placeWithData:[resultArray objectAtIndex:i] type:downloadType];
            if (place.name) {
                char firstLetter = [place.name characterAtIndex:0];
                if (firstLetter >= 'A' && firstLetter <= 'Z') {
                    [[placesArray objectAtIndex:(firstLetter-'A')] addObject:place];
                } else if (firstLetter >= 'a' && firstLetter <- 'z') {
                    [[placesArray objectAtIndex:(firstLetter-'a')] addObject:place];
                } else {
                    [[placesArray lastObject] addObject:place];
                }
            }
        }
        
        // convert placeArray to _tableViewData
        for (int i=0; i<MAX_INDEXES; i++) {
            if ([[placesArray objectAtIndex:i] count] > 0) {
                if (i == MAX_INDEXES-1) {
                    [_tableViewHeaderString addObject:@"#"];
                } else {
                    [_tableViewHeaderString addObject:[NSString stringWithFormat:@"%c", (i+'A')]];
                }
                [_tableViewData addObject:[placesArray objectAtIndex:i]];
            }
        }
    }
    
    [_tableView reloadData];
    [_spinner stopAnimating];
}

- (void)downloadFailed:(DownloadType)downloadType {
    //TODO: handle failure
}

@end
