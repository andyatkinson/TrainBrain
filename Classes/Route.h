//
//  Route.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/2/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Route : NSObject {
	NSString *route_id;
	NSString *long_name;
	NSString *short_name;
	NSString *route_desc;
	NSString *route_type;
	NSString *route_url;
}

@property (nonatomic, retain) NSString *route_id;
@property (nonatomic, retain) NSString *long_name;
@property (nonatomic, retain) NSString *short_name;
@property (nonatomic, retain) NSString *route_desc;
@property (nonatomic, retain) NSString *route_type;
@property (nonatomic, retain) NSString *route_url;

@end
