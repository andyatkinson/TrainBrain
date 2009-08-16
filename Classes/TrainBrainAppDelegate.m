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
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
}






#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	

	[navigationController release];
	[window release];
	[super dealloc];
}


@end

