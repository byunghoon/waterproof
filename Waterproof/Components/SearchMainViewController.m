//
//  SearchMainViewController.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 26..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "SearchMainViewController.h"
#import "WPConnectionManager.h"
#import "WPSearch.h"
#import "Constants.h"
#import "SearchDetailViewController.h"

@interface SearchMainViewController ()

@end

@implementation SearchMainViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _courseArray = [NSMutableArray array];
    _backupArray = [NSMutableArray array];
    
    // stop spinner. (turn on when search started)
    [_spinner stopAnimating];
    
    // Search bar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.placeholder = @"Tab here to begin search.";
    _searchBar.delegate = self;
    
    for(UIView *subView in _searchBar.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *searchField = (UITextField *)subView;
            searchField.font = [UIFont fontWithName:WP_FONT_CONTENT size:15.0f];
        }
    }
    
    if(_downloadType == DownloadTypeExamSchedule) {
        [_spinner startAnimating];
        [[WPConnectionManager instance] download:DownloadTypeExamSchedule delegate:self];
    }
    
    
    // Overlay View - this will show up when keyboard is active.
    int maxY = CGRectGetMaxY(_searchBar.frame);
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, self.view.frame.size.width, self.view.frame.size.height-maxY)];
    _overlayView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _overlayView.hidden = YES;
    [_overlayView addGestureRecognizer:singleTapGestureRecognizer];
    [self.view addSubview:_overlayView];
    searching = NO;
    letUserSelectRow = YES;
    
    _tableView.tableHeaderView = _searchBar;
}


#pragma mark - Helper

- (void)reloadTable {
    [_tableViewData removeAllObjects];
    [_tableViewData addObject:_courseArray];
    
    [_tableView reloadData];
    [_spinner stopAnimating];
}

- (void)dismissKeyboard {
    [_searchBar resignFirstResponder];
    _overlayView.hidden = YES;
}


#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _overlayView.hidden = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissKeyboard];

    if(_downloadType == DownloadTypeExamSchedule) {
        return;
    }
    if ((_downloadType == DownloadTypeProfessorSearch || _downloadType == DownloadTypeCourseSchedule) && searchBar.text.length == 1) {
        [_courseArray removeAllObjects];
        [_backupArray removeAllObjects];
        NSLog(@"NOT FOUND");
        WPSearch *notFound = [[WPSearch alloc] init];
        notFound.name = @"Not Found";
        _tableViewHeaderString = [NSArray arrayWithObjects:@"Result", nil]; // bug fix - app crashed when the first search was a failure
        [_courseArray addObject:notFound];
        [_backupArray addObject:notFound];
        [self reloadTable];
        return;
    }
    
    _tableViewHeaderString = [NSArray arrayWithObjects:@"Result", nil];
    
    [_spinner startAnimating];
    
    //start search
    NSString *searchQuery = searchBar.text;
    [[WPConnectionManager instance] search:_downloadType delegate:self query:searchQuery];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
    // exam schedule only
    if(_downloadType == DownloadTypeExamSchedule) {
        
        [_courseArray removeAllObjects];
        [_courseArray addObjectsFromArray:_backupArray];
        _tableViewHeaderString = [NSArray arrayWithObjects:searchTerm, nil];
        
        if (searchTerm.length > 0) {
        
            // course search
            for(int i = 0; i < _courseArray.count; i++) {
                WPSearch *course = [_courseArray objectAtIndex:i];
                // [[string lowercaseString] rangeOfString:[substring lowercaseString]]
                NSRange rangeString = [course.name rangeOfString:searchTerm options:NSCaseInsensitiveSearch];
                if (rangeString.location == NSNotFound) {
                    [_courseArray removeObjectAtIndex:i];
                    i--;
                }
            }
            
            // course not found
            if(_courseArray.count == 0) {
                WPSearch *notFound = [[WPSearch alloc] init];
                notFound.name = @"Not Found";
                [_courseArray addObject:notFound];
            }
        }
        
        [self reloadTable];
    }
}



#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableViewCellStyleDefault];
    UILabel *textLabel = (UILabel *)[cell viewWithTag:TAG_CELL_LABEL_TITLE];
    
    WPSearch *course = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    textLabel.text = course.name;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WPSearch *search = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    SearchDetailViewController *searchDetailViewController = [[SearchDetailViewController alloc] init];
    
    searchDetailViewController.search = search;
    [self.navigationController pushViewController:searchDetailViewController animated:YES];
    
}


#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];
        
        
    //clear table
    [_courseArray removeAllObjects];
    [_backupArray removeAllObjects];
    if([resultArray count] == 0) {
        NSLog(@"NOT FOUND");
        WPSearch *notFound = [[WPSearch alloc] init];
        notFound.name = @"Not Found";
        _tableViewHeaderString = [NSArray arrayWithObjects:@"Result", nil]; // bug fix - app crashed when the first search was a failure
        [_courseArray addObject:notFound];
        [_backupArray addObject:notFound];
    }
    
    if ([resultArray isKindOfClass:[NSDictionary class]]) {
        _tableViewHeaderString = [NSArray arrayWithObjects:@"Result", nil];
        WPSearch *search = [WPSearch searchWithData:resultArray type:downloadType];
        [_courseArray addObject:search];
        [_backupArray addObject:search];
    } else {
    
        for(NSDictionary *result in resultArray) {
            _tableViewHeaderString = [NSArray arrayWithObjects:@"Result", nil];
            WPSearch *search = [WPSearch searchWithData:result type:downloadType];
            [_courseArray addObject:search];
            [_backupArray addObject:search];
        }
    }
    if(_downloadType == DownloadTypeExamSchedule) {
        _tableViewHeaderString = [NSArray arrayWithObjects:@"Courses", nil];
        
    }
    
    
    [self reloadTable];
    
}

- (void)downloadFailed:(DownloadType)downloadType {
    [_spinner stopAnimating];
}



@end