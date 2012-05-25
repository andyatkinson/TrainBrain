//
//  StopTimesTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stop.h"
#import "MBProgressHUD.h"
#import "BigDepartureTableViewCell.h"

@interface StopTimesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  UITableView *tableView;
  NSMutableArray *data;
  Stop *selectedStop;
  NSArray *stop_times;
  MBProgressHUD *HUD;
  BigDepartureTableViewCell *bigCell;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) BigDepartureTableViewCell *bigCell;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSArray *stop_times;
@property (nonatomic, retain) Stop *selectedStop;

- (void)loadStopTimes;

@end



