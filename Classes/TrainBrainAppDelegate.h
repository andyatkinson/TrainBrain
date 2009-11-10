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
	NSString *selectedHeadsign;
	NSMutableArray *selectedStopId;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void) setSelectedRouteId:(NSString *)newRouteId;
- (NSString *) getSelectedRouteId;

- (void) setSelectedHeadsign:(NSString *)newHeadsign;
- (NSString *) getSelectedHeadsign;

- (void) setSelectedStopId:(NSString *)newStopId;
- (NSString *) getSelectedStopId;

- (NSString *) getBaseUrl;

@end

