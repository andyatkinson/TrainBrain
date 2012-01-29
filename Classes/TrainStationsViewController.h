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
	IBOutlet UITableView *stationsTableView;
	NSMutableData *responseData;
	IBOutlet NSMutableArray *views;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
	Route *selectedRoute;
	MapStopsViewController *mapStopsViewController;
}

@property (nonatomic, retain) IBOutlet UITableView *stationsTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;
@property (nonatomic, retain) Route *selectedRoute;
@property (nonatomic, retain) MapStopsViewController *mapStopsViewController;

-(IBAction)loadMapView:(id)sender;

@end
