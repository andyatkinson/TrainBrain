//
//  Stop.m
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "Stop.h"

@implementation Stop

@synthesize location = _location;
@synthesize stopName = _stopName;
@synthesize street = _street;
@synthesize description = _description;
@synthesize routeId = _routeId;
@synthesize webUrl = _webUrl;
@synthesize routeShortName = _routeShortName;

-(void) dealloc {
	self.location = nil;
	self.stopName = nil;
	self.street = nil;
	self.description = nil;
	self.routeId = nil;
	self.webUrl = nil;
	self.routeShortName = nil;
	[super dealloc];
}

@end
