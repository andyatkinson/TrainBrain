//
//  TrainBrainAppDelegate.h
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

@interface TrainBrainAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;

	NSString *selectedRouteId;
	NSString *headsign;
	NSMutableArray *stopIds;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void) setSelectedRouteId:(NSString *)newRouteId;
- (NSString *) getSelectedRouteId;

- (void) setHeadsign:(NSString *)selectedHeadsign;
- (NSString *) getHeadsign;

- (void) addStopId:(NSString *)newStopId;
- (NSArray *) getStopIds;

- (NSString *) getBaseUrl;

@end

