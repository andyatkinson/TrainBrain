//
//  Stop.m
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Stop.h"

@implementation Stop

@synthesize location = _location;
@synthesize stopName = _stopName;
@synthesize street = _street;
@synthesize description = _description;

-(void) dealloc {
	self.location = nil;
	self.stopName = nil;
	self.street = nil;
	self.description = nil;
	[super dealloc];
}

@end
