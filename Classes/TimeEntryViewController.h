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
#import "Route.h"

@interface TimeEntryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UIWebViewDelegate> {
	UIWebView *webView;
	UITableView *tableView;
	NSMutableData *responseData;
	NSMutableArray *allStopTimes;
	NSMutableArray *leftHeadsignStopTimes;
	NSMutableArray *rightHeadsignStopTimes;
	NSString *leftHeadsign;
	NSString *rightHeadsign;
	
	IBOutlet UIImageView *nextDepartureImage;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
	Route *selectedRoute;
	NSString *selectedStopName;
	NSMutableArray *selectedStops;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableData	*responseData;
@property (nonatomic, retain) NSMutableArray *allStopTimes;
@property (nonatomic, retain) NSMutableArray *leftHeadsignStopTimes;
@property (nonatomic, retain) NSMutableArray *rightHeadsignStopTimes;
@property (nonatomic, retain) IBOutlet UIImageView *nextDepartureImage;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;
@property (nonatomic, retain) Route *selectedRoute;
@property (nonatomic, retain) NSString *selectedStopName;
@property (nonatomic, retain) NSMutableArray *selectedStops;
@property (nonatomic, retain) NSString *leftHeadsign;
@property (nonatomic, retain) NSString *rightHeadsign;

-(IBAction)refreshTimes:(id)sender;

@end
