//
//  TimeEntryController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartureDetailCell.h"
#import "ProgressViewController.h"

@interface TimeEntryController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *timeEntriesTableView;
	NSMutableData *responseData;
	NSString *railStationId;
	NSString *railStationName;
	IBOutlet NSMutableArray *timeEntryRows;
	ProgressViewController *progressViewController;
	NSInteger southbound;
	IBOutlet UILabel *bigTimeHeaderText;
	IBOutlet UILabel *bigTime;
	NSInteger nextTime;
}

@property (nonatomic, retain) IBOutlet UITableView *timeEntriesTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) NSString *railStationId;
@property (nonatomic, retain) NSString *railStationName;
@property (nonatomic, retain) IBOutlet NSMutableArray *timeEntryRows;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic) NSInteger southbound;
@property (nonatomic, retain) IBOutlet UILabel *bigTime;
@property (nonatomic, retain) IBOutlet UILabel *bigTimeHeaderText;
@property (nonatomic) NSInteger nextTime;

-(void)updateSouthbound:(NSInteger) newValue;
-(IBAction)refreshTimes:(id)sender;

@end
