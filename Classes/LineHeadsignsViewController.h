//
//  LineHeadsignsViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
#import "TrainBrainAppDelegate.h"

@interface LineHeadsignsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *headsignsTableView;
	NSMutableData *responseData;
	IBOutlet NSMutableArray *views;
	ProgressViewController *progressViewController;
	TrainBrainAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UITableView *headsignsTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

- (void)mapButtonClicked:(id)sender;

@end
