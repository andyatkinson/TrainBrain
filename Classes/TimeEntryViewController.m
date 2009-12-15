//
//  TimeEntryViewController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//
#import "TimeEntryViewController.h"
#import "JSON/JSON.h"

@interface TimeEntryViewController (Private)
- (void) loadTimeEntries;
@end

@implementation TimeEntryViewController

@synthesize responseData, timeEntryRows, progressViewController, timeEntriesTableView, bigTimeHeaderText, nextDepartureImage, appDelegate;

-(IBAction)refreshTimes:(id)sender {
	[self loadTimeEntries];
}

- (void) loadTimeEntries {
	progressViewController.message = [NSString stringWithFormat:@"Loading Departures..."];
	[self.view addSubview:progressViewController.view];
	[progressViewController startProgressIndicator];
	
	// get the hour and minute to send to server
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int *hour = (int *)[components hour];
	components = [calendar components:NSMinuteCalendarUnit fromDate:now];
	int *minute = (int *)[components minute];

	
	NSString *requestURL = [NSString stringWithFormat:@"%@routes/%@/stops/%@/stop_times.json?time=%d:%d",
													[appDelegate getBaseUrl],
													[appDelegate getSelectedRouteId],
													[appDelegate getSelectedStopId],
													hour,
													minute];
	requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self loadTimeEntries];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	timeEntriesTableView.backgroundColor = [UIColor clearColor];
	responseData = [[NSMutableData data] retain];
	progressViewController = [[ProgressViewController alloc] init];
	appDelegate = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	bigTimeHeaderText.text = [appDelegate getSelectedStopName];
	self.title = @"Departures";
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
	[progressViewController stopProgressIndicator];
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
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];	
	// parse the JSON response into an object
	SBJSON *parser = [[SBJSON alloc] init];
	NSArray *entries = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	
	// now is used for time remaining for each route and for big label
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int nowHour = (int)[components hour];
	components = [calendar components:NSMinuteCalendarUnit fromDate:now];
	int nowMinute = (int)[components minute];
	timeEntryRows = [[NSMutableArray alloc] init];
	int count = [entries count];
	for(int i=0; i < count; i++) {
		NSMutableDictionary *entry = [entries objectAtIndex:i];
		
		NSString *hour = [entry objectForKey:@"hour"];
		NSString *minute = [entry objectForKey:@"minute"];
		NSString *cost = [entry objectForKey:@"cost"];
		NSString *type = [entry objectForKey:@"type"];
		NSString *headsign = [entry objectForKey:@"headsign"];
		
		NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		NSString *entryTime = [NSString stringWithFormat:@"%@:%@", hour, minute];
		
		// method not officially part of iPhone SDK NSDate class, ignore warning
		NSDate *stringTime = [NSDate dateWithNaturalLanguageString:entryTime];
		NSString *formattedDateStringTime = [timeFormatter stringFromDate:stringTime];
		
		int minutesRemaining = 0;
		// return early if the hour is 23, and the next hour is zero, can't do a simple next check on that
		if((int)nowHour == 23 && [hour intValue] == 0) {
			minutesRemaining = (60 - (int)nowMinute) + [minute intValue];
		} else if((int)nowHour == 23 && [hour intValue] == 1) { // 2 hours out!
			minutesRemaining = (120 - (int)nowMinute) + [minute intValue];
		} else if([hour intValue] == (int)nowHour && [minute intValue] > nowMinute) { // happy case, current hour minute is greater
			minutesRemaining = [minute intValue] - (int)nowMinute;
		} else if([hour intValue] == ((int)nowHour + 1)) { // in the next hour, this works except falls down for hour 23 and hour 0 case
			minutesRemaining = (60 - (int)nowMinute) + [minute intValue];
		}
		NSString *minutesRemainingString = [NSString stringWithFormat:@"%d", minutesRemaining];
		
		[timeEntryRows addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
															formattedDateStringTime, @"departureTime",
															cost, @"cost",
															minutesRemainingString, @"minutesRemaining",
															type, @"type",
															headsign, @"headsign",
															nil]];
	}
	
	[timeEntriesTableView reloadData];
	[progressViewController.view	removeFromSuperview];
	[progressViewController stopProgressIndicator];
	
	if([entries count] > 0) {
		
		int count = [entries count];
		NSMutableDictionary *nextDeparture = nil;		
		int nextDepartureHour = 0;
		int nextDepartureMinute = 0;
		for(int i=0; i < count; i++) {
			nextDeparture = [entries objectAtIndex:i];
			nextDepartureHour = (int)[[nextDeparture objectForKey:@"hour"] intValue];
			nextDepartureMinute = (int)[[nextDeparture objectForKey:@"minute"] intValue];
			if(nextDepartureHour > nowHour || (nextDepartureHour == nowHour && nextDepartureMinute >= nowMinute) || (nowHour == 23 && nextDepartureHour == 0)) {
				break; // break out of loop when right time is fetched
			}
		}

		int minutesRemaining = 0;
		//bomb out early for 11PM case
		if(nowHour == 23 && nextDepartureHour == 0) {
			minutesRemaining = (60 - nowMinute) + nextDepartureMinute;

		} else if(nowHour == 23 && nextDepartureHour == 1) { // try to be user friendly and show remaining minutes for 2 hours out
			minutesRemaining = (120 - nowMinute) + nextDepartureMinute;
			
		} else if(nowHour == 23 && nextDepartureHour == 2) { // 3 hours out!
			minutesRemaining = (180 - nowMinute) + nextDepartureMinute;
			
		} else if(nextDepartureHour == nowHour && nextDepartureMinute >= nowMinute) {
			// more than hour out, set label, else show minutes countdown
			minutesRemaining = nextDepartureMinute - nowMinute;
			
		} else if(nextDepartureHour == (nowHour+1)) { // departure in the next hour
			minutesRemaining = (60 - nowMinute) + nextDepartureMinute;
		}
		
		
	} else { // ERROR handling, for some reason there were 0 or less departure times returned from the server

		
		[timeEntriesTableView reloadData];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Departures Found." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


// table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [timeEntryRows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 66.0f;
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
	
		if([timeEntryRows count] > 0) {
			[[cell departureTime] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"departureTime"]];
			[[cell departureCost] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"cost"]];
			[[cell headsign] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"headsign"]];
			[[cell type] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"type"]];
			[cell	departureIcon].image = [UIImage imageNamed:@"clock.png"];
			[cell setBackgroundColor:[UIColor whiteColor]];
			
			minutes = [[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"minutesRemaining"] intValue];			
			if(minutes > 0 && minutes < 6) { // ensure only set for between 1 and 5 minutes
				[cell	departureIcon].image = [UIImage imageNamed:@"exclamation.png"];
				[cell setBackgroundColor:[UIColor yellowColor]];
			}
			
			if(minutes == 0) {
				// don't show zero in the table cell could be in the past, or calculation could have failed
				[[cell timeRemaining] setText:@""];
			} else {
				[[cell timeRemaining] setText:[[NSString alloc] initWithFormat:@"%d min", minutes]];
			}
		}
		return cell;

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	[timeEntryRows release];
	[responseData release];
	[timeEntriesTableView release];
	[progressViewController release];
	[bigTimeHeaderText release];
	[super dealloc];
}


@end
