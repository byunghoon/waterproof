//
//  EditCourseViewController.m
//  Waterproof
//
//  Created by CheulSoon Baek on 13. 1. 22..
//  Copyright (c) 2013년 Kokkiri. All rights reserved.
//

#import "EditCourseViewController.h"
#import "WPDatabaseManager.h"
#import "Constants.h"

@interface EditCourseViewController ()

@end

@implementation EditCourseViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Textfield
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(WP_MARGIN_L, WP_MARGIN_L, self.view.frame.size.width - WP_MARGIN_L*2, self.view.frame.size.height / 4)];
    _courses = [[WPDatabaseManager instance] getCourseStringForType:DataTypeCurrentCourses];
    
    _textView.text = _courses;
    [_textView setFont:[UIFont fontWithName:@"arial" size:15]];
    
    UILabel *instruction = [[UILabel alloc] initWithFrame:CGRectMake(WP_MARGIN_L, WP_MARGIN_L*2 + _textView.frame.size.height, self.view.frame.size.width - WP_MARGIN_L * 2, self.view.frame.size.height / 5)];
    instruction.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:231.0/255.0 blue:232.0/255.0 alpha:1.0];
    instruction.text = @"Example: CS 115, CS 116, MATH 135";
    instruction.textColor = [UIColor colorWithRed:100.0/255.0 green:101.0/255.0 blue:102.0/255.0 alpha:0.5];
    
    [self.view addSubview:_textView];
    [self.view addSubview:instruction];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveCourses)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    
}

#pragma mark - Helper

- (void) saveCourses {
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure to save courses?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [_alertView show];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(alertView == self.alertView){
		if (buttonIndex == 1){
            [[WPDatabaseManager instance] setCourseString:_textView.text forType:DataTypeCurrentCourses];
            _textView.text = [[WPDatabaseManager instance] getCourseStringForType:DataTypeCurrentCourses];
            [self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
}

@end
