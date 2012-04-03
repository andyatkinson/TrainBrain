//
//  StopTimesTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopTimesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *tableView;
  NSMutableArray *data;
  NSString *stopID;
  NSString *routeID;
  NSArray *stop_times;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSArray *stop_times;
@property (nonatomic, retain) NSString *routeID;
@property (nonatomic, retain) NSString *stopID;

- (void)loadStopTimes;

@end



