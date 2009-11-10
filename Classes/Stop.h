//
//  Stop.h
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Stop : NSObject {
	CLLocation *_location;
	NSString *_stopName;
	NSString *_street;
	NSString *_description;
	NSString *_routeId;
}

@property(nonatomic, copy) CLLocation *location;
@property (nonatomic, retain) NSString *stopName;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *routeId;

@end
