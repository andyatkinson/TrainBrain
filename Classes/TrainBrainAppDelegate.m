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

#import "GAI.h"

static const NSInteger kGANDispatchPeriodSec = 10;
static NSString *const kTrackingId = @"XXX"; // Something like UA-12997631-4

@implementation TrainBrainAppDelegate

@synthesize window, routesTableViewController, infoTableViewController, tabBarController, tracker;

- (NSString*) getDeviceName {
  NSArray *chunks = [[[UIDevice currentDevice] name] componentsSeparatedByString: @"'"];
  NSString *deviceName = [[NSString alloc] initWithString:[chunks objectAtIndex:0]];
  return deviceName;
}

- (void) saveAnalytics:(NSString*) pageName {
  if([[self getDeviceName] isEqualToString:@"iPhone Simulator"]){
    NSLog(@"Skip GA in Simulator: %@", pageName);
    //return;
  }
  
  [self.tracker trackView:pageName];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
  [self saveAnalytics:@"Entry"];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  // Initialize Google Analytics
  [GAI sharedInstance].debug = NO;
  [GAI sharedInstance].dispatchInterval = kGANDispatchPeriodSec;
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
  [self saveAnalytics:@"Entry"];
  
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