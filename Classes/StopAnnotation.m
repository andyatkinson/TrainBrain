//
//  StopAnnotation.m
//  TrainBrain
//
//  Created by Andy Atkinson on 9/20/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "StopAnnotation.h"
#import "Stop.h"

@implementation StopAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize stop = _stop;

+(id)annotationWithStop:(Stop *)stop {
	return [[[[self class] alloc] initWithStop:stop] autorelease];
}

-(id)initWithStop:(Stop *)stop {
	self = [super init];
	if(nil != self) {
		self.title = stop.stopName;
		self.subtitle = [NSString stringWithFormat:@"%@ - Route %@", stop.description, stop.routeShortName];
		self.coordinate = stop.location.coordinate;
		self.stop = stop;
	}
	return self;
}

-(void)dealloc {
	[super dealloc];
}

@end