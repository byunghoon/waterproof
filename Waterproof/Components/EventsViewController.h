//
//  EventViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-21.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPTableViewController.h"
#import "WPConnectionManager.h"

@interface EventsViewController : WPTableViewController <DownloadDelegate> {
    NSMutableArray *_eventsArray;
    int activeConnections;
}

@end
