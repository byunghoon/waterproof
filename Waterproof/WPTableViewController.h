//
//  WPDefaultTableViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-26.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPConnectionManager.h"

#define TAG_CELL_LABEL_TITLE 201
#define TAG_CELL_LABEL_DETAIL 202

#define DEFAULT_CELL_HEIGHT 44.0

@interface WPTableViewController : WPBaseViewController <DownloadDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_tableViewHeaderString;
    NSMutableArray *_tableViewData;
    
    UIActivityIndicatorView *_spinner;
    
    BOOL searchBarEnabled;
    BOOL showChevron;
}

- (UITableViewCell *)tableViewCellStyleDefault;
- (UITableViewCell *)tableViewCellStyleDetailedForHeight:(float)height;

@end
