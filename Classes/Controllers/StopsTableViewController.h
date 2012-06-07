//
//  StopsTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SVSegmentedControl.h"
#import "Route.h"
#import "MBProgressHUD.h"

@interface StopsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MBProgressHUDDelegate> {
  UITableView *tableView;
  NSArray *headsigns;
  NSArray *stops;
  NSArray *stopsIndex0;
  NSArray *stopsIndex1;
  
  NSMutableArray *data;
  Route *selectedRoute;
  
  CLLocation *myLocation;
  CLLocationManager *locationManager;
  MBProgressHUD *HUD;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *headsigns;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSArray *stopsIndex0;
@property (nonatomic, retain) NSArray *stopsIndex1;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) Route *selectedRoute;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;
- (void)loadMapView;

@end
