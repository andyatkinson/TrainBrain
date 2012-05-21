//
//  TrainBrainAppDelegate.h
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

@interface TrainBrainAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITableViewController *routesTableViewController;
	UIViewController      *infoViewController;	
    UITableViewController *infoTableViewController;	
	UITabBarController    *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITableViewController	*routesTableViewController;
@property (nonatomic, retain) UIViewController *infoViewController;
@property (nonatomic, retain) UITableViewController *infoTableViewController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;


@end

