//
//  TimeEntryViewController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//
#import "TimeEntryViewController.h"
#import "JSON/JSON.h"
#import "StopTime.h"

@interface TimeEntryViewController (Private)
- (void) loadTimeEntries;
@end

@implementation TimeEntryViewController

@synthesize allStopTimes, leftHeadsignStopTimes, rightHeadsignStopTimes, tableView, nextDepartureImage, appDelegate, selectedRoute, 
selectedStopName, selectedStops, webView, leftHeadsign, rightHeadsign, timeEntries, timeEntry;

-(IBAction)refreshTimes:(id)sender {
	[self loadTimeEntry];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
    
    HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Departures";
	[HUD show:YES];
	

	[self loadTimeEntry];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	
	NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
	
	if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"trainbrain"]) {
		if([(NSString *)[components objectAtIndex:1] isEqualToString:@"clicked"]) {
			
			NSString *headsignKey = [components objectAtIndex:2];
			
			if ([headsignKey isEqualToString:self.leftHeadsign]) {
				NSRange range = NSMakeRange(0, allStopTimes.count-1);
				[self.allStopTimes replaceObjectsInRange:range withObjectsFromArray:leftHeadsignStopTimes];
			} else if ([headsignKey isEqualToString:self.rightHeadsign]) {
				NSRange range = NSMakeRange(0, allStopTimes.count-1);
				[self.allStopTimes replaceObjectsInRange:range withObjectsFromArray:rightHeadsignStopTimes];
			}
			
			[self.tableView reloadData];
		
		}
		return NO;
	}
	return YES; // Return YES to make sure regular navigation works as expected.
}

- (void)loadView
{
	UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0,50,360,540) style:UITableViewStylePlain];
	tv.rowHeight = 66.0f;
	self.tableView = tv;
	[tableView release];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,360.0,100)];
	self.webView = webView;
	webView.delegate = self;
	
	UIView *container = [[UIView alloc] init];
	[container addSubview:webView];
	[container addSubview:tv];

	self.view = container;
	[container release];
	
	self.tableView.dataSource = self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTimes:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];	
	
	appDelegate = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.title = selectedStopName;
}

- (void)loadTimeEntry {

    // get the hour and minute to send to server
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int *_hour = (int *)[components hour];
    NSString *hour = [[NSString alloc] initWithFormat:@"%d", _hour];
	
	NSString *stopIdString = [[self.selectedStops valueForKey:@"stop_id"] componentsJoinedByString:@","];
    NSString *requestURL = [NSString stringWithFormat:@"train/v1/routes/%@/stops/%@/stop_times", self.selectedRoute.route_id, stopIdString];
    
    allStopTimes = [[NSMutableArray alloc] init];
    leftHeadsignStopTimes = [[NSMutableArray alloc] init];	
    rightHeadsignStopTimes = [[NSMutableArray alloc] init];

    [StopTime stopTimesWithURLString:requestURL near:nil parameters:[NSDictionary dictionaryWithObject:hour forKey:@"hour"] block:^(NSArray *records) {
        
        [HUD hide:YES];
        self.timeEntries = records;
        self.timeEntry = [timeEntries objectAtIndex:0];
        
        self.leftHeadsign = [self.timeEntry.headsign_keys objectAtIndex:0];
        if ([self.timeEntry.headsign_keys count] == 2) {
            self.rightHeadsign = [self.timeEntry.headsign_keys objectAtIndex:1];
        }
        
        for (StopTime *st in self.timeEntry.stop_times) {
            [self.allStopTimes addObject:st];
            
            if ([st.headsign_key isEqualToString:self.leftHeadsign]) {
                [self.leftHeadsignStopTimes addObject:st];
                
            } else if ([st.headsign_key isEqualToString:self.rightHeadsign]) {
                [self.rightHeadsignStopTimes addObject:st];
            }
        }

        [self.webView loadHTMLString:self.timeEntry.template baseURL:[NSURL URLWithString:@""]];
        
        [self.tableView reloadData];
    }];
    
    
}


// table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.allStopTimes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *cellId = @"DepartureDetailCell";
	int minutes = 0;
	DepartureDetailCell *cell = (DepartureDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];

	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DepartureDetailCell" owner:nil options:nil];
	
	for(id currrentObject in nibObjects) {
		if([currrentObject isKindOfClass:[DepartureDetailCell class]]) {
			cell = (DepartureDetailCell *)currrentObject;
		}
	}

	// set the gradient
	cell.backgroundView = [[[GradientView alloc] init] autorelease];

	if([self.allStopTimes count] > 0) {
        StopTime *stop_time = (StopTime *)[self.allStopTimes objectAtIndex:indexPath.row];
        
		[[cell departureTime] setText:stop_time.departure_time];
		[[cell departureCost] setText:stop_time.price];
		[[cell headsign] setText:stop_time.headsign];
		
		[cell departureIcon].image = [UIImage imageNamed:@"clock.png"];
		[cell setBackgroundColor:[UIColor whiteColor]];
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
        int hour = (int)[components hour];
        components = [calendar components:NSMinuteCalendarUnit fromDate:now];
        int minute = (int)[components minute];
        
        NSArray *parts = [stop_time.departure_time componentsSeparatedByString:@":"];
        int _hour = (int)[[parts objectAtIndex:0] intValue];
        int _mins = (int)[[parts objectAtIndex:1] intValue];
        
        NSString *minutes_from_now = @"";
        
        if (hour == _hour && minute < _mins) {
            minutes_from_now = [[NSString alloc] initWithFormat:@"%d", (_mins - minute)];
        } 
		
		minutes = (int)[minutes_from_now intValue];
		if (0 < minutes && minutes < 6) {
			[cell	departureIcon].image = [UIImage imageNamed:@"exclamation.png"];
			cell.backgroundView = [[[YellowGradientView alloc] init] autorelease];
		} else if (minutes == 0) {
			// don't show zero in the table cell could be in the past, or calculation could have failed
			[[cell timeRemaining] setText:@""];
		} else {
			[[cell timeRemaining] setText:[[NSString alloc] initWithFormat:@"%d min", minutes]];
		}
	}
	return cell;
}

- (void)viewDidUnload {
	self.tableView = nil;
	
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)hudWasHidden
{
}

- (void)dealloc {
	[allStopTimes release];
	[leftHeadsignStopTimes release];
	[rightHeadsignStopTimes release];
	[tableView release];
	[HUD release];
	[super dealloc];
}


@end
