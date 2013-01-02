//
//  EventViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-21.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPTableViewController.h"

@interface EventsViewController : WPTableViewController {
    NSMutableArray *_dailyEventsArray;
    NSMutableArray *_dateSpecificEventsArray;
    int activeConnections;
}

@end
