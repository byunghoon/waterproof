//
//  PlaceListViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "PlaceListViewController.h"
#import "PlaceDetailViewController.h"

#define CUSTOM_CELL_HEIGHT 70.0

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
    UITableViewCell *cell = nil;
    WPPlace *place = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (place.placeType == PlaceTypeBuildings) {
        cell = [self tableViewCellStyleDetailedForHeight:CUSTOM_CELL_HEIGHT];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_TITLE];
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_DETAIL];
        
        titleLabel.text = place.acronym;
        detailLabel.text = place.name;
    } else if (place.placeType == PlaceTypeParking && place.parkingType == ParkingTypeVisitor) {
        cell = [self tableViewCellStyleDetailedForHeight:CUSTOM_CELL_HEIGHT];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_TITLE];
        UILabel *detailLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_DETAIL];
        
        titleLabel.text = place.name;
        if (place.costInfo2) {
            detailLabel.text = [NSString stringWithFormat:@"%@ | %@", place.costInfo1, place.costInfo2];
        } else {
            detailLabel.text = place.costInfo1;
        }
    } else {
        cell = [self tableViewCellStyleDefault];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_TITLE];
        
        titleLabel.text = place.name;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPPlace *place = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (place.placeType == PlaceTypeBuildings) {
        return CUSTOM_CELL_HEIGHT;
    } else if (place.placeType == PlaceTypeParking && place.parkingType == ParkingTypeVisitor) {
        return CUSTOM_CELL_HEIGHT;
    } else {
        return DEFAULT_CELL_HEIGHT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlaceDetailViewController *placeDetailViewController = [[PlaceDetailViewController alloc] init];
    placeDetailViewController.place = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:placeDetailViewController animated:YES];
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
            if (place.name) {
                if (place.parkingType == ParkingTypeVisitor) {
                    [[_tableViewData objectAtIndex:0] addObject:place];
                } else if (place.parkingType == ParkingTypeStudentPermit) {
                    [[_tableViewData objectAtIndex:1] addObject:place];
                } else if (place.parkingType == ParkingTypeFacultyAndStaff) {
                    [[_tableViewData objectAtIndex:2] addObject:place];
                } else if (place.parkingType == ParkingTypeResident) {
                    [[_tableViewData objectAtIndex:3] addObject:place];
                } else {
                    // Disregard short term and meter parking lots for now.
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
            NSString *pivot = (place.placeType==PlaceTypeBuildings) ? place.acronym : place.name;
            if (pivot) {
                char firstLetter = [pivot characterAtIndex:0];
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
    [_spinner stopAnimating];
}

@end
