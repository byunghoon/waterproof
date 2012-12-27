//
//  SearchMainViewController.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 26..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "SearchMainViewController.h"
#import "WPConnectionManager.h"
#import "WPCourse.h"
#import "Constants.h"

@interface SearchMainViewController ()

@end

@implementation SearchMainViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _courseArray = [NSMutableArray array];
    
    // stop spinner. (turn on when search started)
    [_spinner stopAnimating];
    
    searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    searchbar.tintColor = WP_YELLOW;
    searchbar.placeholder = @"Query";
    searchbar.delegate = self;
    _tableView.tableHeaderView = searchbar;

}

#pragma mark - Helper
- (void)reloadTable {
    [_tableViewData removeAllObjects];
    [_tableViewData addObject:_courseArray];
    
    [_tableView reloadData];
    [_spinner stopAnimating];
}

#pragma mark - UISearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    _tableView.allowsSelection = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchQuery = searchBar.text;
    [_spinner startAnimating];
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchBar resignFirstResponder];
    self.navigationItem.title = searchQuery;
    
    
    //start search
    [[WPConnectionManager instance] search:_downloadType delegate:self query:searchQuery];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	searchBar.showsCancelButton = NO;
	[searchBar resignFirstResponder];
}

/*
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm {
}
 */

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self defaultTableViewCell];
    
    WPCourse *course = [[_tableViewData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = course.name;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}


#pragma mark - DownloadDelegate

- (void)downloadSucceeded:(DownloadType)downloadType data:(id)data {
    NSArray *resultArray = [[[data objectForKey:@"response"] objectForKey:@"data"] objectForKey:@"result"];

    //clear table
    [_courseArray removeAllObjects];
    
    
    if(downloadType == DownloadTypeCourseSearch) {
        for(NSDictionary *result in resultArray) {
            _tableViewHeaderString = [NSArray arrayWithObjects:@"Result", nil];
            WPCourse *course = [WPCourse courseWithData:result type:downloadType];
            [_courseArray addObject:course];
        }
    }
    
    
    [self reloadTable];
    
}

- (void)downloadFailed:(DownloadType)downloadType {
    [_spinner stopAnimating];
}



@end