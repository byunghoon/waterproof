//
//  SearchMainViewController.h
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 26..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "WPTableViewController.h"

@interface SearchMainViewController : WPTableViewController <UISearchBarDelegate> {
    UISearchBar *_searchBar;
    UIView *_overlayView;
    
    NSMutableArray *_courseArray;
}

@property (nonatomic) DownloadType downloadType;

@end
