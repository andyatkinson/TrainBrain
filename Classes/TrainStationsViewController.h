//
//  TrainStationsViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainBrainAppDelegate.h"
#import "CustomCell.h"
#import "StationCell.h"
#import "MBProgressHUD.h"
#import "GradientView.h"
#import "Route.h"
#import "MapStopsViewController.h"

@interface TrainStationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
	IBOutlet UITableView *tableView;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
	Route *selectedRoute;
	MapStopsViewController *mapStopsViewController;
	CLLocation *my_location;
  NSArray *stop_groups;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;
@property (nonatomic, retain) Route *selectedRoute;
@property (nonatomic, retain) MapStopsViewController *mapStopsViewController;
@property (nonatomic, retain) CLLocation *my_location;
@property (readwrite, nonatomic, retain) NSArray *stop_groups;

-(IBAction)loadMapView:(id)sender;

@end
