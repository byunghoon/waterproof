//
//  EventDetailViewController.h
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 22..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPEvent.h"

@interface EventDetailViewController : WPBaseViewController {
    UILabel *titleOfEvent;
    UILabel *dateOfEvent;
    UITextView *descriptionOfEvent;
    UITextView *linksOfEvent;
}

@property (nonatomic, strong) WPEvent *selectedEvent;

@end
