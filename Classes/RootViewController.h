//
//  RootViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomCell.h"
#import "ProgressViewController.h"


@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
	IBOutlet UITableView *stationsTableView;
	IBOutlet NSMutableArray *views;
	NSMutableArray *railStations;
	NSMutableData *responseData;
	CLLocationManager *locationManager;
	CLLocation *startingPoint;
	ProgressViewController *progressViewController;
	NSInteger southbound;
}

@property (nonatomic, retain) IBOutlet UITableView *stationsTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) NSMutableArray *railStations;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic) NSInteger southbound;

-(void)updateSouthbound:(NSInteger) newValue;

-(IBAction)toggleDirection:(id)sender;
-(IBAction)refreshStations:(id)sender;

@end
