//
//  WPBaseViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"

#define STATUS_BAR_HEIGHT   20

@interface WPBaseViewController ()

@end

@implementation WPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - STATUS_BAR_HEIGHT);
}

@end
