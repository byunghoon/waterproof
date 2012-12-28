//
//  SearchViewController.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-25.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchMainViewController.h"
#import "Constants.h"

#define BUTTON_SIZE 157.0

@interface SearchViewController ()

@end

@implementation SearchViewController


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
    
    UIButton *courseInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    courseInfoButton.frame = CGRectMake(0, CGRectGetMaxY(logoView.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    courseInfoButton.backgroundColor = WP_YELLOW;
    [courseInfoButton setTitle:@"Course Info" forState:UIControlStateNormal];
    [courseInfoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [courseInfoButton addTarget:self action:@selector(courseInfoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:courseInfoButton];
    
    UIButton *professorsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    professorsButton.frame = CGRectMake(self.view.frame.size.width-BUTTON_SIZE, CGRectGetMaxY(logoView.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    professorsButton.backgroundColor = WP_YELLOW;
    [professorsButton setTitle:@"Professors" forState:UIControlStateNormal];
    [professorsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [professorsButton addTarget:self action:@selector(profButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:professorsButton];
    
    UIButton *courseScheduleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    courseScheduleButton.frame = CGRectMake(0, CGRectGetMaxY(courseInfoButton.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    courseScheduleButton.backgroundColor = WP_YELLOW;
    [courseScheduleButton setTitle:@"Course Schedule" forState:UIControlStateNormal];
    [courseScheduleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [courseScheduleButton addTarget:self action:@selector(courseScheduleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:courseScheduleButton];
    
    UIButton *examButton = [UIButton buttonWithType:UIButtonTypeCustom];
    examButton.frame = CGRectMake(self.view.frame.size.width-BUTTON_SIZE, CGRectGetMaxY(courseInfoButton.frame)+WP_MARGIN_M, BUTTON_SIZE, BUTTON_SIZE);
    examButton.backgroundColor = WP_YELLOW;
    [examButton setTitle:@"Exam Schedule" forState:UIControlStateNormal];
    [examButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [examButton addTarget:self action:@selector(examButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:examButton];
}


- (void)courseInfoButtonPressed {
    SearchMainViewController *searchMainViewController = [[SearchMainViewController alloc] init];
    searchMainViewController.downloadType = DownloadTypeCourseSearch;
    [self.navigationController pushViewController:searchMainViewController animated:YES];
}

- (void)profButtonPressed {
    SearchMainViewController *searchMainViewController = [[SearchMainViewController alloc] init];
    searchMainViewController.downloadType = DownloadTypeProfessorSearch;
    [self.navigationController pushViewController:searchMainViewController animated:YES];
}

- (void)courseScheduleButtonPressed {
    SearchMainViewController *searchMainViewController = [[SearchMainViewController alloc] init];
    searchMainViewController.downloadType = DownloadTypeCourseSchedule;
    [self.navigationController pushViewController:searchMainViewController animated:YES];
}

- (void)examButtonPressed {
    SearchMainViewController *searchMainViewController = [[SearchMainViewController alloc] init];
    searchMainViewController.downloadType = DownloadTypeExamSchedule;
    [self.navigationController pushViewController:searchMainViewController animated:YES];
}

@end
