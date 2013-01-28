//
//  SettingsViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "SettingsViewController.h"
#import "WPDatabaseManager.h"
#import "WPTableViewController.h"
#import "EditCourseViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _courseStrings = [NSMutableArray array];
    _chevronFlags = [NSMutableArray array];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    if (courseChanged == YES) {
        [self loadData];
        courseChanged = NO;
    }
    [super viewDidAppear:animated];
}


#pragma mark - Helper

- (void)loadData {
    NSNumber *yes = [NSNumber numberWithBool:YES];
    NSNumber *no = [NSNumber numberWithBool:NO];
    
    courses = [[[WPDatabaseManager instance] getCourseArrayForType:DataTypeCurrentCourses] copy];
    // reset data
    [_courseStrings removeAllObjects];
    [_chevronFlags removeAllObjects];
    for (NSDictionary *course in courses) {
        [_courseStrings addObject:[NSString stringWithFormat:@"%@ %@", [[course objectForKey:@"subject"] uppercaseString], [course objectForKey:@"number"]]];
        [_chevronFlags addObject:no];
    }
    
    [_courseStrings addObject:@"Edit Courses"];
    [_chevronFlags addObject:yes];
    
    // Table Data
    
    self.rawHeaders = [NSArray arrayWithObjects:@"My Courses", @"About", @"Version", @"Developers", nil];
    self.rawData = [NSArray arrayWithObjects:
                    _courseStrings,
                    [NSArray arrayWithObjects:@"WaterProof", @"Kokkiri", nil],
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey],
                    [NSArray arrayWithObjects:@"Byunghoon Yoon", @"Cheulsoon Baek", nil], nil];
    self.showChevronFlag = [NSArray arrayWithObjects:
                            _chevronFlags,
                            [NSArray arrayWithObjects:yes, yes, nil],
                            [NSArray arrayWithObject:no],
                            [NSArray arrayWithObjects:yes, yes, nil], nil];
}


#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *header;
    NSArray *data;
    if (indexPath.section == 0 && indexPath.row == [courses count]) {
        
        /*
         Course entry view will be consist of two textviews (editable, keyboard pops up when tapped)
            and a done button (preferably as a rightBarButtonItem).
         Each label will contain 'raw strings' of past/current courses.
         Raw string is a string of courses separated by commas, with each courses being subject and number,
            separated by a space.
         
         Example: @"ECON 101, AFM 102, CS 135" is a valid raw string.
         
         Use WPDatabaseManager's getter and setter method. WPDatabaseManager is complete.
         */
        courseChanged = YES;
        EditCourseViewController *editCourseViewController = [[EditCourseViewController alloc] init];
        [self.navigationController pushViewController:editCourseViewController animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        header = [NSArray arrayWithObjects:@"Project WaterProof", @"Disclaimer", @"Copyright", nil];
        data = [NSArray arrayWithObjects:@"Powered by the Waterloo API, WaterProof is an ongoing, ambitious project to stand as Waterloo's number one student guideline. The motive under the project is to \"let the knowns be known\"; our primary goal is to help the students fully utilize various kinds of information provided by the university.",
                [NSArray arrayWithObjects:@"This application is absolutely free and ad-free.", @"We do not guarantee the accuracy of the information provided by this application, as some of the Waterloo API modules are in beta.", nil],
                @"Byunghoon Yoon, Cheulsoon Baek \u00A9 2013", nil];
    } else if(indexPath.section == 1 && indexPath.row == 1) {
        header = [NSArray arrayWithObject:@"Kokkiri"];
        data = [NSArray arrayWithObject:@"jju bbu jju bbu"];
    } else if(indexPath.section == 3 && indexPath.row == 0) {
        header = [NSArray arrayWithObjects:@"Byunghoon Yoon", @"Links", nil];
        data = [NSArray arrayWithObjects:@"Byunghoon Yoon is a computer science student at the University of Waterloo. His main interests are mobile application development, UI/UX design, computer security and computer architecture.", @"http://byunghoon.net/", nil];
    } else if(indexPath.section == 3 && indexPath.row == 1) {
        header = [NSArray arrayWithObject:@"Cheulsoon Baek"];
        data = [NSArray arrayWithObject:@"handsome guy"];
    }
    
    if (header && data) {
        WPGroupViewController *groupViewController = [[WPGroupViewController alloc] init];
        groupViewController.rawHeaders = header;
        groupViewController.rawData = data;
        
        [self.navigationController pushViewController:groupViewController animated:YES];
    }
}


@end
