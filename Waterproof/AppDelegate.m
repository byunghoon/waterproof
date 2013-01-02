//
//  AppDelegate.m
//  Waterproof
//
//  Created by Byunghoon Yoon on 12-12-20.
//  Copyright (c) 2012 Kokkiri. All rights reserved.
//

#import "AppDelegate.h"

#import "Constants.h"
#import "EventsViewController.h"
#import "SearchViewController.h"
#import "PlacesViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Navigation Bar
    EventsViewController *eventsViewController = [[EventsViewController alloc] init];
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:eventsViewController];
    firstNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Events" image:nil tag:0];
    [firstNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_events_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_events"]];
    [firstNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    secondNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:nil tag:1];
    [secondNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_search_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_search"]];
    [secondNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    PlacesViewController *placesViewController = [[PlacesViewController alloc] init];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc] initWithRootViewController:placesViewController];
    thirdNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Places" image:nil tag:2];
    [thirdNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_places_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_places"]];
    [thirdNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    UINavigationController *fourthNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    fourthNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:nil tag:3];
    [fourthNavigationController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_settings_hl"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_settings"]];
    [fourthNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"navbar_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, backButtonImage.size.height*2) forBarMetrics:UIBarMetricsDefault];
    
    
    // Tab Bar
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[firstNavigationController, secondNavigationController, thirdNavigationController, fourthNavigationController];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected"]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:WP_FONT_TITLE size:11.0f], UITextAttributeFont,
                                                       [UIColor whiteColor], UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont fontWithName:WP_FONT_TITLE size:11.0f], UITextAttributeFont,
                                                       WP_YELLOW, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
