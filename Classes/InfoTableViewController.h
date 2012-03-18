//
//  InfoTableViewController.h
//  TrainBrain
//
//  Created by Aaron Batalion on 3/17/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
  NSMutableArray *dataArrays;
  UITableView *tableView;
}

@property (nonatomic, retain) NSMutableArray *dataArrays;
@property (nonatomic, retain) UITableView *tableView;


@end
