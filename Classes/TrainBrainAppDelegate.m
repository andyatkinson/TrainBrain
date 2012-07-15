//
//  TrainBrainAppDelegate.m
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright Andy Atkinson 2009 http://webandy.com. All rights reserved.
//

#import "TrainBrainAppDelegate.h"
#import "RoutesTableViewController.h"
#import "StopsTableViewController.h"
#import "StopTimesTableViewController.h"
#import "InfoTableViewController.h"

@implementation TrainBrainAppDelegate

@synthesize window, routesTableViewController, infoTableViewController, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    UIImage *navigationBarImage = [UIImage imageNamed:@"bg_header.png"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
  
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	
    tabBarController = [[UITabBarController alloc] init];
    routesTableViewController = [[RoutesTableViewController alloc] init];
    UINavigationController *routesController = [[[UINavigationController alloc] initWithRootViewController:routesTableViewController] autorelease];
    routesController.navigationBar.barStyle = UIBarStyleDefault;
    routesController.tabBarItem.title = @"Departures";
    routesController.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];
    [routesTableViewController release];
	
    infoTableViewController = [[InfoTableViewController alloc] init];
    UINavigationController *infoController = [[[UINavigationController alloc] initWithRootViewController:infoTableViewController] autorelease];
    infoController.navigationBar.barStyle = UIBarStyleDefault;
    infoController.title = @"Info";
    infoController.tabBarItem.image = [UIImage imageNamed:@"nav_info_norm.png"];
    [infoTableViewController release];
	
    tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, infoController, nil];
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
  [routesTableViewController release];
  [infoTableViewController release];
	[tabBarController release];
	[window release];
	[super dealloc];
}

@end