//
//  TrainBrainAppDelegate.m
//  TrainBrain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TrainBrainAppDelegate.h"

@implementation TrainBrainAppDelegate

@synthesize window, navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[window addSubview:[navigationController view]];

	// Override point for customization after app launch	
	[window makeKeyAndVisible];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	

	[navigationController release];
	[window release];
	[super dealloc];
}


@end

