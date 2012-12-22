//
//  EventViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-21.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPConnectionManager.h"

@interface EventsViewController : UIViewController <DownloadDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_eventsArray;
    
    UIActivityIndicatorView *_spinner;
    
    int activeConnections;
}

@end
