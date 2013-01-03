//
//  WPGroupedTableViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 13-01-02.
//  Copyright (c) 2013 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"

#define MARGIN_GROUP_CELL       10.0
#define WIDTH_CELL              300.0
#define WIDTH_LABEL             280.0

@interface WPGroupViewController : WPBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    
    NSMutableArray *_tableViewHeaderString;
    NSMutableArray *_tableViewData;
    NSMutableArray *_specialDataFlag;
}

@property (nonatomic, strong) NSArray *rawHeaders;
@property (nonatomic, strong) NSArray *rawData;

@end
