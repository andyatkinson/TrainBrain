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


- (void) setHeadsign:(NSString *)selectedHeadsign {
	headsign = selectedHeadsign;
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"dataChangeEvent" object:self];
}
- (NSString *) getHeadsign {
	return headsign;
}

- (void)dealloc {

	[navigationController release];
	[window release];
	[super dealloc];
}


@end

