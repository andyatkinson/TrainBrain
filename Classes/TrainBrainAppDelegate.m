//
//  TrainBrainAppDelegate.m
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright Andy Atkinson 2009 http://webandy.com. All rights reserved.
//

#import "TrainBrainAppDelegate.h"

@implementation TrainBrainAppDelegate

@synthesize window, navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[window addSubview:[navigationController view]];
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

- (NSString *) getBaseUrl {
	return @"http://localhost:3000/";
	//return @"http://trainbrain-api2.heroku.com/";
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end