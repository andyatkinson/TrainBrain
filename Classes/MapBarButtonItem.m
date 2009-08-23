//
//  MapBarButtonItem.m
//  train brain
//
//  Created by Andy Atkinson on 7/19/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import "MapBarButtonItem.h"

@implementation MapBarButtonItem

@synthesize locationLat, locationLng, stationLat, stationLng;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
	[super dealloc];
	[locationLat release];
	[locationLng release];
	[stationLat release];
	[stationLng release];
}

@end
