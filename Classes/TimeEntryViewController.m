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

@synthesize responseData, allStopTimes, leftHeadsignStopTimes, rightHeadsignStopTimes, tableView, nextDepartureImage, appDelegate, selectedRoute, selectedStopName, selectedStops, webView;

-(IBAction)refreshTimes:(id)sender {
	// TODO add refresh button
	[self loadTimeEntries];
}

- (void) loadTimeEntries {
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Departures";
	[HUD show:YES];
	
	// get the hour and minute to send to server
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int *hour = (int *)[components hour];
	
	NSArray *stop_ids = [selectedStops valueForKey:@"stop_id"];
	NSString *stopIds = [stop_ids componentsJoinedByString:@","];
	NSLog(@"[debug] stop_ids: %@", stopIds);
	
	NSString *requestURL = [NSString stringWithFormat:@"%@train/v1/routes/%@/stops/%@/stop_times.json?hour=%d", 
													[appDelegate getBaseUrl], 
													selectedRoute.route_id, 
													stopIds,
													hour];
	NSLog(@"request URL: %@", requestURL);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];

	// TODO investigate request caching
}


- (void)viewDidAppear:(BOOL)animated {

	
	[super viewDidAppear:animated];
	

	[self loadTimeEntries];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	
	NSString *requestString = [[request URL] absoluteString];
	NSArray *components = [requestString componentsSeparatedByString:@":"];
	
	if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"trainbrain"]) {
		if([(NSString *)[components objectAtIndex:1] isEqualToString:@"clicked"]) {
			NSLog([components objectAtIndex:2]); // param1
			
			NSString *headsignKey = [components objectAtIndex:2];
			
			if ([headsignKey isEqualToString:@"north_55_downtown_minneapolis"]) {
				NSRange range = NSMakeRange(0, allStopTimes.count-1);
				[self.allStopTimes replaceObjectsInRange:range withObjectsFromArray:leftHeadsignStopTimes];
			} else if ([headsignKey isEqualToString:@"south_55_mall_of_america"]) {
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
	UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0,50,340,410) style:UITableViewStylePlain];
	self.tableView = tv;
	[tableView release];
	
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,360.0,100)];
	self.webView = webView;
	//NSString *url = [NSString stringWithFormat:@"http://localhost:3000/switcher"]; // load a template in the request, just for testing
//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//	[webView loadRequest:request];
	
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
	responseData = [[NSMutableData data] retain];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTimes:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];	
	responseData = [[NSMutableData data] retain];
	
	appDelegate = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.title = selectedStopName;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network connection failed. \n\n Ensure Airplane Mode is not enabled and a network connection is available." 
																									message:nil 
																								 delegate:nil 
																				cancelButtonTitle:@"OK" 
																				otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	SBJSON *parser = [[SBJSON alloc] init];
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSDictionary *dict = [jsonString JSONValue];
	
	NSArray *headsigns = [dict objectForKey:@"headsigns"];
	NSString *switcherHTML = [dict objectForKey:@"template"];
	NSString *stopTimeString = [dict objectForKey:@"stop_times"];
	
	NSArray *records = [parser objectWithString:stopTimeString error:nil];
	
	[parser release];
	[jsonString release];

	[webView loadHTMLString:switcherHTML baseURL:[NSURL URLWithString:@""]]; 
	
	allStopTimes = [[NSMutableArray alloc] init];	
	leftHeadsignStopTimes = [[NSMutableArray alloc] init];	
	rightHeadsignStopTimes = [[NSMutableArray alloc] init];	

	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int hour = (int)[components hour];
	components = [calendar components:NSMinuteCalendarUnit fromDate:now];
	int minute = (int)[components minute];
	
	if ([records count] > 0) {
		for (id _record in records) {
			NSDictionary *_stop_time = [_record objectForKey:@"stop_time"];
			
			StopTime *stop_time = [[StopTime alloc] init];
			stop_time.departure_time = [_stop_time objectForKey:@"departure_time"];
			stop_time.arrival_time = [_stop_time objectForKey:@"arrival_time"];
			stop_time.drop_off_type = [_stop_time objectForKey:@"drop_off_type"];
			stop_time.pickup_type = [_stop_time objectForKey:@"pickup_type"];
			stop_time.price = [_stop_time objectForKey:@"price"];
			stop_time.headsign = [_stop_time objectForKey:@"headsign"];
			stop_time.headsign_key = [_stop_time objectForKey:@"headsign_key"];
	
			NSArray *parts = [stop_time.departure_time componentsSeparatedByString:@":"];
			int _hour = (int)[[parts objectAtIndex:0] intValue];
			int _mins = (int)[[parts objectAtIndex:1] intValue];
	
			if (hour == _hour && minute < _mins) {
				stop_time.minutes_from_now = [[NSString alloc] initWithFormat:@"%d", (_mins - minute)];
			} else {
				stop_time.minutes_from_now = @"";
			}

			[allStopTimes addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
																stop_time, @"stop_time",
																nil]];
			
			if ([headsigns count] == 2) {
				NSString *leftHeadsign = [headsigns objectAtIndex:0];
				NSString *rightHeadsign = [headsigns objectAtIndex:1];
				
				if ([stop_time.headsign_key isEqualToString:leftHeadsign]) {
					[leftHeadsignStopTimes addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
																						stop_time, @"stop_time",
																						nil]];
					
				} else if ([stop_time.headsign_key isEqualToString:rightHeadsign]) {
					[rightHeadsignStopTimes addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
																						 stop_time, @"stop_time",
																						 nil]];
				}
			}
			
			
		}
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No departure times found." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	
	// set the table stop times data to one headsign direction explicitly
	NSRange range = NSMakeRange(0, allStopTimes.count-1);
	[self.allStopTimes replaceObjectsInRange:range withObjectsFromArray:rightHeadsignStopTimes];
	
	[tableView reloadData];
	[HUD hide:YES];
}


// table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [allStopTimes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 56;
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

	if([allStopTimes count] > 0) {
		StopTime *stop_time = (StopTime *)[[allStopTimes objectAtIndex:indexPath.row] objectForKey:@"stop_time"];
		[[cell departureTime] setText:stop_time.departure_time];
		[[cell departureCost] setText:stop_time.price];
		[[cell headsign] setText:stop_time.headsign];
		
		[cell	departureIcon].image = [UIImage imageNamed:@"clock.png"];
		[cell setBackgroundColor:[UIColor whiteColor]];
		
		minutes = (int)[stop_time.minutes_from_now intValue];
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
	[responseData release];
	[tableView release];
	[HUD release];
	[super dealloc];
}


@end
