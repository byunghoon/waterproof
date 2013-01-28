//
//  SearchDetailViewController.h
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 27..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "WPGroupViewController.h"
#import "WPSearch.h"

@interface SearchDetailViewController : WPGroupViewController

@property (nonatomic, strong) WPSearch *search;
@property (nonatomic, retain) UIWebView *webView;

@end
