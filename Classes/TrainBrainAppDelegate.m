//
//  TrainBrainAppDelegate.m
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright Andy Atkinson 2009 http://webandy.com. All rights reserved.
//

#import "TrainBrainAppDelegate.h"
#import "RootViewController.h"
#import "RoutesTableViewController.h"
#import "InfoViewController.h"
#import "InfoTableViewController.h"

@implementation TrainBrainAppDelegate

@synthesize window, routesTableViewController, infoViewController, infoTableViewController, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  
  // START data storage in plist file
//  NSError *error;
//  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *documentsDirectory = [paths objectAtIndex:0];
//  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user_data.plist"];
//  
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  
//  if (![fileManager fileExistsAtPath: path])
//  {
//    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
//    [fileManager copyItemAtPath:bundle toPath: path error:&error];
//  }
  // END data storage in plist file
  
  // Create image for navigation background - portrait
  UIImage *navigationBarImage = [UIImage imageNamed:@"bg_header.png"];
  [[UINavigationBar appearance] setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
  
	
	//[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	UIColor *navBarColor = UIColorFromRGB(0x111111);
	
	tabBarController = [[UITabBarController alloc] init];
  //routesTableViewController = [[RootViewController alloc] init];
  routesTableViewController = [[RoutesTableViewController alloc] init];
  
	UINavigationController *routesController = [[[UINavigationController alloc] initWithRootViewController:routesTableViewController] autorelease];
  routesController.navigationBar.barStyle = UIBarStyleDefault;
  routesController.navigationBar.tintColor = navBarColor;
  routesController.tabBarItem.title = @"Departures";
  routesController.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];
	[routesTableViewController release];
	
	infoTableViewController = [[InfoTableViewController alloc] init];
	UINavigationController *infoController = [[[UINavigationController alloc] initWithRootViewController:infoTableViewController] autorelease];
	//infoController.navigationBar.barStyle = UIBarStyleDefault;
	//infoController.navigationBar.tintColor = navBarColor;
	infoController.title = @"Info";
	infoController.tabBarItem.image = [UIImage imageNamed:@"90-lifebuoy.png"];
	[infoTableViewController release];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, infoController, nil];
	[window addSubview:tabBarController.view];

	
	[window makeKeyAndVisible];
}

- (void)dealloc {
	//[navigationController release];
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end