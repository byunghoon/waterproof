//
//  WPGroupedTableViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 13-01-02.
//  Copyright (c) 2013 Kokkiri. All rights reserved.
//

#import "WPBaseViewController.h"

@interface WPGroupViewController : WPBaseViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    
    NSMutableArray *_tableViewHeaderString;
    NSMutableArray *_tableViewData;
}

@property (nonatomic, strong) NSArray *rawHeaders;
@property (nonatomic, strong) NSArray *rawData;

@end
