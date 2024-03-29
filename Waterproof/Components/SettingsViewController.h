//
//  SettingsViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPGroupViewController.h"

@interface SettingsViewController : WPGroupViewController {
    NSMutableArray *courses;
    BOOL courseChanged;
}
@property (strong, nonatomic) NSMutableArray *courseStrings;
@property (strong, nonatomic) NSMutableArray *chevronFlags;

@end
