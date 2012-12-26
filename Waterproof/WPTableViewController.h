//
//  WPDefaultTableViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPConnectionManager.h"

@interface WPTableViewController : WPBaseViewController <DownloadDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_tableViewHeaderString;
    NSMutableArray *_tableViewData;
    
    UIActivityIndicatorView *_spinner;
    
    BOOL searchBarEnabled;
}

- (UITableViewCell *)defaultTableViewCell;

@end
