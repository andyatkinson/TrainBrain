//
//  StopTime.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StopTime : NSObject {
	NSString *departure_time;
	NSString *arrival_time;
	NSString *drop_off_type;
	NSString *pickup_type;
	NSString *price;
	NSString *minutes_from_now;
	NSString *headsign;
}

@property (nonatomic, retain) NSString *departure_time;
@property (nonatomic, retain) NSString *arrival_time;
@property (nonatomic, retain) NSString *drop_off_type;
@property (nonatomic, retain) NSString *pickup_type;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *minutes_from_now;
@property (nonatomic, retain) NSString *headsign;

@end
