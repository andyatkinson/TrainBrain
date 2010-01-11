//
//  TrainBrainAppDelegate.h
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

@interface TrainBrainAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  UIWindow *window;
  //UINavigationController *navigationController;
	UITableViewController *routesTableViewController;
	UIViewController *mapStopsViewController;
	UIViewController *infoViewController;

	NSString *selectedRouteId;
	NSString *selectedHeadsign;
	NSString *selectedStopId;
	NSString *selectedStopName; 
	
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITableViewController	*routesTableViewController;
@property (nonatomic, retain) UIViewController *mapStopsViewController;
@property (nonatomic, retain) UIViewController *infoViewController;
//@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (void) setSelectedRouteId:(NSString *)newRouteId;
- (NSString *) getSelectedRouteId;

- (void) setSelectedHeadsign:(NSString *)newHeadsign;
- (NSString *) getSelectedHeadsign;

- (void) setSelectedStopId:(NSString *)newStopId;
- (NSString *) getSelectedStopId;

- (void) setSelectedStopName:(NSString *)newStopName;
- (NSString *) getSelectedStopName;

- (NSString *) getBaseUrl;


@end

