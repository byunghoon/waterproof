//
//  WPBaseViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"
#import "Constants.h"

@interface WPBaseViewController ()

@end

@implementation WPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:231.0/255.0 blue:232.0/255.0 alpha:1.0];
    self.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - STATUS_BAR_HEIGHT);
}

@end
