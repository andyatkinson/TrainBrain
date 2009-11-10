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

- (void) setHeadsign:(NSString *)selectedHeadsign {
	headsign = selectedHeadsign;
}
- (NSString *) getHeadsign {
	return headsign;
}

- (void) addStopId:(NSString *)newStopId {
	if(stopIds == nil) {
		stopIds = [[NSMutableArray alloc] init];
	}
	[stopIds addObject:newStopId];
}

- (NSArray *) getStopIds {
	return stopIds;
}

- (NSString *) getBaseUrl {
	return @"http://trainbrain-api2.heroku.com/";
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end