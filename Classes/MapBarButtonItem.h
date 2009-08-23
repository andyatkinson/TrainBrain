//
//  MapBarButtonItem.h
//  train brain
//
//  Created by Andy Atkinson on 7/19/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MapBarButtonItem : UIBarButtonItem {
	NSString *locationLat;
	NSString *locationLng;
	NSString *stationLat;
	NSString *stationLng;
}

@property (nonatomic, retain) NSString *locationLat;
@property (nonatomic, retain) NSString *locationLng;
@property (nonatomic, retain) NSString *stationLat;
@property (nonatomic, retain) NSString *stationLng;

@end
