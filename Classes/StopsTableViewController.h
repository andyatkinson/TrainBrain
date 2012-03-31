//
//  StopsTableViewController.h
//  TrainBrain
//
//  Created by Aaron Batalion on 3/26/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SVSegmentedControl.h"

@interface StopsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
  UITableView *tableView;
  NSArray *headsigns;
  NSArray *stops;
  
  NSMutableArray *data;
  NSString *selected_route_id;
  
  CLLocation *myLocation;
  CLLocationManager *locationManager;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *headsigns;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *selected_route_id;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;

@end
