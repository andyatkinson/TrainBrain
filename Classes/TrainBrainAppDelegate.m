//
//  TrainBrainAppDelegate.m
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright Andy Atkinson 2009 http://webandy.com. All rights reserved.
//

#import "TrainBrainAppDelegate.h"
#import "RootViewController.h"
#import "InfoViewController.h"

@implementation TrainBrainAppDelegate

@synthesize window, routesTableViewController, infoViewController, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	UIColor *navBarColor = UIColorFromRGB(0x111111);
	
	tabBarController = [[UITabBarController alloc] init];
	routesTableViewController = [[RootViewController alloc] init];
	UINavigationController *routesController = [[[UINavigationController alloc] initWithRootViewController:routesTableViewController] autorelease];
	routesController.navigationBar.barStyle = UIBarStyleDefault;
	routesController.navigationBar.tintColor = navBarColor;
	routesTableViewController.title = @"Routes";
	routesController.tabBarItem.title = @"Departures";
	routesController.tabBarItem.image = [UIImage imageNamed:@"11-clock.png"];
	[routesTableViewController release];
	
	infoViewController = [[InfoViewController alloc] init];
	UINavigationController *infoController = [[[UINavigationController alloc] initWithRootViewController:infoViewController] autorelease];
	infoController.navigationBar.barStyle = UIBarStyleDefault;
	infoController.navigationBar.tintColor = navBarColor;
	infoController.title = @"Help";
	infoController.tabBarItem.image = [UIImage imageNamed:@"90-lifebuoy.png"];
	[infoViewController release];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, infoController, nil];
	[window addSubview:tabBarController.view];

	
	[window makeKeyAndVisible];
}

- (NSString *) getBaseUrl {
	// IMPORTANT: ensure trailing slash is present.
	//return @"http://api2.trainbrainapp.com/";
	return @"http://localhost:3000/";
	//return @"http://trainbrain-api3.heroku.com/";
}

- (void)dealloc {
	//[navigationController release];
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end