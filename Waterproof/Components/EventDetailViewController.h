//
//  EventDetailViewController.h
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 22..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPEvent.h"

@interface EventDetailViewController : UIViewController{
 
    IBOutlet UILabel *titleOfEvent;
    IBOutlet UILabel *dateOfEvent;
    IBOutlet UITextView *descriptionOfEvent;
    IBOutlet UITextView *linksOfEvent;
    WPEvent *selectedEvent;
}

@property (nonatomic, retain) WPEvent *selectedEvent;

@end
