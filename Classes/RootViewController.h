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
#import "TrainLineCell.h"
#import "TrainBrainAppDelegate.h"
#import "MapStopsViewController.h"
#import "MBProgressHUD.h"
#import "GradientView.h"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MBProgressHUDDelegate> {
	IBOutlet UITableView *tableView;
	CLLocationManager *locationManager;
	CLLocation *startingPoint;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
    NSArray *routes;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;
@property (readwrite, nonatomic, retain) NSArray *routes;

-(IBAction)refreshStations:(id)sender;

@end
