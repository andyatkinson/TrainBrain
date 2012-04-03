//
//  StopTimesTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"
#import "Stop.h"

@interface StopTimesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *tableView;
  NSMutableArray *data;
  Stop *selectedStop;
  Route *selectedRoute;
  NSArray *stop_times;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSArray *stop_times;
@property (nonatomic, retain) Route *selectedRoute;
@property (nonatomic, retain) Stop *selectedStop;

- (void)loadStopTimes;

@end


