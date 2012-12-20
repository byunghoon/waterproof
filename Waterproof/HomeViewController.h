//
//  HomeViewController.h
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTableView.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    WPTableView *_tableView;
    NSArray *_tableViewData;
}

@end
