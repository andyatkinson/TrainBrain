//
//  StationsViewController.h
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomCell.h"
#import "ProgressViewController.h"
#import "MapViewController.h"

@interface StationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
	IBOutlet UITableView *stationsTableView;
	IBOutlet NSMutableArray *views;
	NSMutableArray *railStations;
	NSMutableData *responseData;
	CLLocationManager *locationManager;
	CLLocation *startingPoint;
	ProgressViewController *progressViewController;
	NSInteger southbound;
	IBOutlet UISegmentedControl *directionControl;
	NSString *mapURL;
}

@property (nonatomic, retain) IBOutlet UITableView *stationsTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) NSMutableArray *railStations;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startingPoint;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic) NSInteger southbound;
@property (nonatomic, retain) IBOutlet UISegmentedControl *directionControl;
@property (nonatomic, retain) NSString *mapURL;

-(void)updateSouthbound:(NSInteger) newValue;

-(IBAction)toggleDirection:(id)sender;
-(IBAction)refreshStations:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)mapButtonClicked:(id)sender; 

@end