//
//  NewsViewController.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/26/10.
//  Copyright 2010 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainBrainAppDelegate.h"
#import "MBProgressHUD.h"
#import "GradientView.h"
#import "NewsCell.h"

@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate> {
	IBOutlet NSMutableArray *views;
	IBOutlet UITableView *newsTableView;
	NSMutableData *responseData;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UITableView *newsTableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) IBOutlet NSMutableArray *views;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

-(IBAction)refreshNews:(id)sender;

@end
