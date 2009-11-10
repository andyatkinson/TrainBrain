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

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
	IBOutlet UITableView *linesTableView;
	IBOutlet NSMutableArray *views;
	NSMutableData *responseData;
	CLLocationManager *locationManager;
	CLLocation *startingPoint;
	ProgressViewController *progressViewController;
	NSInteger southbound;
	TrainBrainAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UITableView *linesTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

-(IBAction)refreshStations:(id)sender;

@end
