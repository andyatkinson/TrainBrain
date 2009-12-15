//
//  RootViewController.h
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomCell.h"
#import "ProgressViewController.h"
#import "TrainBrainAppDelegate.h"
#import "MapStopsViewController.h"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
	IBOutlet UITableView *routesTableView;
	IBOutlet NSMutableArray *views;
	NSMutableData *responseData;
	CLLocationManager *locationManager;
	CLLocation *startingPoint;
	ProgressViewController *progressViewController;
	TrainBrainAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UITableView *routesTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

-(IBAction)refreshStations:(id)sender;
- (void)mapButtonClicked:(id)sender;

@end
