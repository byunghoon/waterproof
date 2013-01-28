//
//  SearchDetailViewController.m
//  Waterproof
//
//  Created by CheulSoon Baek on 12. 12. 27..
//  Copyright (c) 2012년 Kokkiri. All rights reserved.
//

#import "SearchDetailViewController.h"


@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *headers;
    NSArray *data;
    NSNumber *yes = [NSNumber numberWithBool:YES];
    NSNumber *no = [NSNumber numberWithBool:NO];
    switch (_search.type) {
        case courseSearch: {
            headers = [NSArray arrayWithObjects:@"Name", @"Title", @"Description", nil];
            data = [NSArray arrayWithObjects:_search.name, _search.title, _search.description, nil];
            break;
        }
        case profSearch: {
            headers = [NSArray arrayWithObjects:@"Name", @"Department", @"Rate my prof", nil];
            data = [NSArray arrayWithObjects:_search.name, _search.department, @"GO", nil];
            self.showChevronFlag = [NSArray arrayWithObjects:
                                    [NSArray arrayWithObjects:no,nil],
                                    [NSArray arrayWithObjects:no,nil],
                                    [NSArray arrayWithObjects:yes,nil],nil];
            break;
        }
        case examSearch: {
            headers = [NSArray arrayWithObjects:@"Name", @"Section", @"Location", @"Day", @"Time", nil];
            data = [NSArray arrayWithObjects:_search.name2, _search.section, _search.location,[[_search.day stringByAppendingString:@" "] stringByAppendingString:_search.date], [[_search.startTime stringByAppendingString:@" - "] stringByAppendingString:_search.endTime], nil];
            break;
        }
        case scheduleSearch: {
            headers = [NSArray arrayWithObjects:@"Name", @"Section", @"Campus Location", @"Credit", @"Room", @"Time", nil];
            data = [NSArray arrayWithObjects:_search.name2, _search.section, _search.campusLocation, _search.credit, [_search.building stringByAppendingString:_search.room], [_search.days stringByAppendingString:[@" " stringByAppendingString:[[_search.startTime stringByAppendingString:@" - "] stringByAppendingString:_search.endTime]]], nil];
            break;
        }
    }
    
    
    
    
    self.rawHeaders = headers;
    self.rawData = data;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(_search.type == profSearch) {
        if(indexPath.section == 2) {
            _webView = [[UIWebView alloc] init];
            NSString *urlstring = [@"http://www.ratemyprofessors.com/ShowRatings.jsp?tid=" stringByAppendingString:_search.rateMyProfID];
            NSURL *url =[NSURL URLWithString:urlstring];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
