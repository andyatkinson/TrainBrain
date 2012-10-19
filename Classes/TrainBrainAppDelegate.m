//
//  TrainBrainAppDelegate.m
//  train brain
//
//  Copyright 2009 Beetle Fight, LLC. All rights reserved.
//

#import "TrainBrainAppDelegate.h"
#import "RoutesTableViewController.h"
#import "StopsTableViewController.h"
#import "StopTimesTableViewController.h"
#import "InfoTableViewController.h"

#import "GANTracker.h"
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation TrainBrainAppDelegate

@synthesize window, routesTableViewController, infoTableViewController, tabBarController;

- (void) saveAnalytics:(NSString*) pageName {
  
  [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-34997631-2" 
                                         dispatchPeriod:kGANDispatchPeriodSec
                                               delegate:nil];
  
  NSError *error;
  
  if (![[GANTracker sharedTracker] trackPageview:pageName
                                       withError:&error]) {
    // Handle error here
  }
  
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
  [self saveAnalytics:@"/app_entry_point"];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [self saveAnalytics:@"/app_entry_point"];
  
    UIImage *navigationBarImage = [UIImage imageNamed:@"bg_header.png"];
    [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
	
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
    infoController.tabBarItem.image = [UIImage imageNamed:@"icon_info.png"];
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