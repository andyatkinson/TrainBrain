//
//  Stop.h
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Stop : NSObject {
	CLLocation *_location;
	NSString *_stopName;
	NSString *_street;
	NSString *_description;
	NSString *_routeId;
	NSString *_webUrl;
	NSString *_routeShortName;
}

@property(nonatomic, copy) CLLocation *location;
@property (nonatomic, retain) NSString *stopName;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *routeId;
@property (nonatomic, retain) NSString *webUrl;
@property (nonatomic, retain) NSString *routeShortName;

@end
