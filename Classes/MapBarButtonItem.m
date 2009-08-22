//
//  MapBarButtonItem.m
//  TrainBrain
//
//  Created by Andy Atkinson on 7/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
