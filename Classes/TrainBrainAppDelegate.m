//
//  TrainBrainAppDelegate.m
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright Andy Atkinson 2009 http://webandy.com. All rights reserved.
//

#import "TrainBrainAppDelegate.h"
#import "RootViewController.h"
#import "MapStopsViewController.h"
#import "InfoViewController.h"

@implementation TrainBrainAppDelegate

@synthesize window, routesTableViewController, mapStopsViewController, infoViewController, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	UIColor *navBarColor = UIColorFromRGB(0x643716);
	
	tabBarController = [[UITabBarController alloc] init];
	routesTableViewController = [[RootViewController alloc] init];
	UINavigationController *routesController = [[[UINavigationController alloc] initWithRootViewController:routesTableViewController] autorelease];
	routesController.navigationBar.barStyle = UIBarStyleBlack;
	routesController.navigationBar.tintColor = navBarColor;
	routesController.title = @"Routes";
	[routesTableViewController release];
	
	mapStopsViewController = [[MapStopsViewController alloc] init];
	UINavigationController *mapController = [[[UINavigationController alloc] initWithRootViewController:mapStopsViewController] autorelease];
	mapController.navigationBar.barStyle = UIBarStyleBlack;
	mapController.navigationBar.tintColor = navBarColor;
	mapController.title = @"Map";
	[mapStopsViewController release];
	
	infoViewController = [[InfoViewController alloc] init];
	UINavigationController *infoController = [[[UINavigationController alloc] initWithRootViewController:infoViewController] autorelease];
	infoController.navigationBar.barStyle = UIBarStyleBlack;
	infoController.navigationBar.tintColor = navBarColor;
	infoController.title = @"Info";
	[infoViewController release];
	
	tabBarController.viewControllers = [NSArray arrayWithObjects:routesController, mapController, infoController, nil];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
}

- (void) setSelectedRouteId:(NSString *)newRouteId {
	selectedRouteId = newRouteId;
}
- (NSString *) getSelectedRouteId {
	return selectedRouteId;
}

- (void) setSelectedHeadsign:(NSString *)newHeadsign {
	selectedHeadsign = newHeadsign;
}
- (NSString *) getSelectedHeadsign {
	return selectedHeadsign;
}
- (void) setSelectedStopId:(NSString *)newStopId {
	selectedStopId = newStopId;
}
- (NSString *) getSelectedStopId {
	return selectedStopId;
}

- (void) setSelectedStopName:(NSString *)newStopName {
	selectedStopName = newStopName;
}
- (NSString *) getSelectedStopName {
	return selectedStopName;
}

- (NSString *) getBaseUrl {
	// IMPORTANT: ensure trailing slash is present.
	//return @"http://api2.trainbrainapp.com/";
	return @"http://0.0.0.0:3000/";
}

- (void)dealloc {
	//[navigationController release];
	[tabBarController release];
	[window release];
	[super dealloc];
}


@end