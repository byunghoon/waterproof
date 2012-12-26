//
//  EventDetailViewController.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 22..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "EventDetailViewController.h"
#import "Constants.h"

#define LABEL_MARGIN    10

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Lable Set
    // - Title
    titleOfEvent = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_MARGIN, LABEL_MARGIN, self.view.frame.size.width - 2*LABEL_MARGIN, 50)];
    titleOfEvent.backgroundColor = [UIColor orangeColor];
    titleOfEvent.text = _selectedEvent.name;
    // - Description
    descriptionOfEvent = [[UITextView alloc] initWithFrame:CGRectMake(LABEL_MARGIN, 70, self.view.frame.size.width - 2*LABEL_MARGIN, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height - 70 - 70)];
    descriptionOfEvent.textColor = [UIColor blackColor];
    descriptionOfEvent.backgroundColor = [UIColor lightGrayColor];
    descriptionOfEvent.text = _selectedEvent.description;
    // - Links
    linksOfEvent = [[UITextView alloc] initWithFrame:CGRectMake(LABEL_MARGIN, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height - 70, self.view.frame.size.width - 2*LABEL_MARGIN, 50)];
    linksOfEvent.editable = NO;
    linksOfEvent.backgroundColor = [UIColor yellowColor];
    linksOfEvent.text = _selectedEvent.links;
    
    // View Setting
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleOfEvent];
    [self.view addSubview:descriptionOfEvent];
    [self.view addSubview:linksOfEvent];
    
    // Title Setting
    self.navigationItem.title = @"TODAY";
}

@end
