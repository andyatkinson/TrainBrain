//
//  TrainBrainAppDelegate.h
//  train brain
//
//  Copyright 2009 Beetle Fight, LLC. All rights reserved.
//

@interface TrainBrainAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  UIWindow *window;
  UITableViewController *routesTableViewController;
  UITableViewController *infoTableViewController;	
	UITabBarController    *tabBarController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITableViewController	*routesTableViewController;
@property (nonatomic, retain) UITableViewController *infoTableViewController;
@property (nonatomic, retain) UITabBarController *tabBarController;

- (void) saveAnalytics:(NSString*) pageName;

@end

