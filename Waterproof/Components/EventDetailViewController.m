//
//  EventDetailViewController.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 22..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
@synthesize selectedEvent;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    int margin = 10;
    int titleHeight = 50;
    
    // Lable Set
    // - Title
    titleOfEvent = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, self.view.frame.size.width - 2*margin, titleHeight)];
    titleOfEvent.backgroundColor = [UIColor orangeColor];
    titleOfEvent.text = selectedEvent.name;
    // - Description
    descriptionOfEvent = [[UITextView alloc] initWithFrame:CGRectMake(margin, 70, self.view.frame.size.width - 2*margin, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height - 70 - 70)];
    descriptionOfEvent.textColor = [UIColor blackColor];
    descriptionOfEvent.backgroundColor = [UIColor lightGrayColor];
    descriptionOfEvent.text = selectedEvent.description;
    // - Links
    linksOfEvent = [[UITextView alloc] initWithFrame:CGRectMake(margin, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height - 70, self.view.frame.size.width - 2*margin, 50)];
    linksOfEvent.editable = NO;
    linksOfEvent.backgroundColor = [UIColor yellowColor];
    linksOfEvent.text = selectedEvent.links;
    
    // View Setting
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleOfEvent];
    [self.view addSubview:descriptionOfEvent];
    [self.view addSubview:linksOfEvent];
    
    // Title Setting
    self.navigationItem.title = @"TODAY";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
