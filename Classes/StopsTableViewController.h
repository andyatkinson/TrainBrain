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
  NSArray *stops;
  NSMutableArray *data;
  
  CLLocation *myLocation;
  CLLocationManager *locationManager;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl;

@end
