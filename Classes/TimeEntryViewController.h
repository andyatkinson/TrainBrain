//
//  TimeEntryViewController.h
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartureDetailCell.h"
#import "ProgressViewController.h"
#import "TrainBrainAppDelegate.h"

@interface TimeEntryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *timeEntriesTableView;
	NSMutableData *responseData;
	IBOutlet NSMutableArray *timeEntryRows;
	ProgressViewController *progressViewController;
	NSInteger southbound;
	IBOutlet UILabel *bigTimeHeaderText;
	IBOutlet UILabel *bigTime;
	IBOutlet UILabel *upcomingDeparturesLabel;
	IBOutlet UIImageView *nextDepartureImage;
	TrainBrainAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UITableView *timeEntriesTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *timeEntryRows;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic) NSInteger southbound;
@property (nonatomic, retain) IBOutlet UILabel *bigTime;
@property (nonatomic, retain) IBOutlet UILabel *bigTimeHeaderText;
@property (nonatomic, retain)	IBOutlet UILabel *upcomingDeparturesLabel;
@property (nonatomic, retain) IBOutlet UIImageView *nextDepartureImage;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

-(IBAction)refreshTimes:(id)sender;

@end
