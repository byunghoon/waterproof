//
//  SettingsViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rawHeaders = [NSArray arrayWithObjects:@"My Courses", @"About", @"Version", @"Developers", nil];
    self.rawData = [NSArray arrayWithObjects:
                    @"Edit Corses",
                    [NSArray arrayWithObjects:@"WaterProof", @"Kokkiri", nil],
                    [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey],
                    [NSArray arrayWithObjects:@"Byunghoon Yoon", @"Cheulsoon Baek", nil], nil];
    
    NSNumber *yes = [NSNumber numberWithBool:YES];
    NSNumber *no = [NSNumber numberWithBool:NO];
    self.showChevronFlag = [NSArray arrayWithObjects:
                            [NSArray arrayWithObject:yes],
                            [NSArray arrayWithObjects:yes, yes, nil],
                            [NSArray arrayWithObject:no],
                            [NSArray arrayWithObjects:yes, yes, nil], nil];
}

@end
