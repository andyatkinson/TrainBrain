//
//  StationAnnotation.m
//  TrainBrain
//
//  Created by Andy Atkinson on 9/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StationAnnotation.h"


@implementation StationAnnotation

@synthesize coordinate, title, subtitle;

-(void)dealloc {
	[title release];
	[subtitle release];
	[super dealloc];
}

@end