//
//  TimeEntryViewController.h
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartureDetailCell.h"
#import "TrainBrainAppDelegate.h"
#import "MBProgressHUD.h"
#import "GradientView.h"
#import "YellowGradientView.h"
#import "Stop.h"

@interface TimeEntryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
	IBOutlet UITableView *timeEntriesTableView;
	NSMutableData *responseData;
	IBOutlet NSMutableArray *timeEntryRows;
	IBOutlet UIImageView *nextDepartureImage;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
	Stop *selectedStop;
}

@property (nonatomic, retain) IBOutlet UITableView *timeEntriesTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *timeEntryRows;
@property (nonatomic, retain) IBOutlet UIImageView *nextDepartureImage;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;
@property (nonatomic, retain) Stop *selectedStop;

-(IBAction)refreshTimes:(id)sender;

@end
