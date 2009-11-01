//
//  TrainLinesViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 10/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ProgressViewController.h"


@interface TrainLinesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
	IBOutlet UITableView *trainLinesTableView;
	IBOutlet NSMutableArray *views;
	NSMutableArray *lines;
	NSMutableData *responseData;
	CLLocationManager *locationManager;
	CLLocation *startingPoint;
	ProgressViewController *progressViewController;
	NSString *mapURL;
}

@property (nonatomic, retain) UITableView *trainLinesTableView;
@property (nonatomic, retain) NSMutableArray *views;
@property (nonatomic, retain)	NSMutableArray *lines; 
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic, retain) NSString *mapURL;

-(IBAction)refreshTrainLines:(id)sender;

@end
