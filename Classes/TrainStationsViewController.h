//
//  TrainStationsViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainBrainAppDelegate.h"
#import "CustomCell.h"
#import "StationCell.h"
#import "MBProgressHUD.h"

@interface TrainStationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
	IBOutlet UITableView *stationsTableView;
	NSMutableData *responseData;
	IBOutlet NSMutableArray *views;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UITableView *stationsTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

@end
