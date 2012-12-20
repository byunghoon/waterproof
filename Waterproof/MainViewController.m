//
//  ViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *homeViewContorller = [[HomeViewController alloc] init];
    
    navController = [[UINavigationController alloc] initWithRootViewController:homeViewContorller];
    navController.view.frame = self.view.frame;
    navController.navigationBar.tintColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    [self.view addSubview:navController.view];
}

@end
