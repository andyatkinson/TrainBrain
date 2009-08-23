//
//  TimeEntryController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import "TimeEntryController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"

@interface TimeEntryController (Private)
- (void) loadTimeEntries;
@end

@implementation TimeEntryController

@synthesize responseData, railStationId, railStationName, timeEntryRows, progressViewController, southbound, timeEntriesTableView, 
bigTime, bigTimeHeaderText, upcomingDeparturesLabel, nextDepartureImage;

- (void)updateSouthbound:(NSInteger)newVal {
	self.southbound = newVal;
}

-(IBAction)refreshTimes:(id)sender {
	[self loadTimeEntries];
}

- (void) loadTimeEntries {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = [NSString stringWithFormat:@"Loading Upcoming Departures..."];
	self.progressViewController = pvc;
	[self.view addSubview:pvc.view];

	// TODO probably could instantiate/use a time entry object
	responseData = [[NSMutableData data] retain];
	
	// get the hour and minute to send to server
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int *hour = (int *)[components hour];
	components = [calendar components:NSMinuteCalendarUnit fromDate:now];
	int *minute = (int *)[components minute];
	
	// TODO get the UISegmentedControl value for setting north/south
	// Setting it from one view controller to another which is not a good solution	
	NSString *stationTimeEntries = [NSString stringWithFormat:@"http://api.trainbrainapp.com/rail_stations/%@/time_entries.json?t=%d:%d&s=%d", 
																	[self railStationId],
																	hour,
																	minute,
																	[self southbound]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stationTimeEntries]];
	
	timeEntryRows = nil;
	// kick off the request, the view is reloaded from the request handler
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self loadTimeEntries];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	timeEntriesTableView.backgroundColor = [UIColor clearColor];
	
	// set the title of the main navigation
	self.title = [self railStationName];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
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
		
		NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		NSString *entryTime = [NSString stringWithFormat:@"%@:%@", hour, minute];
		
		// method not officially part of iPhone SDK NSDate class, ignore warning
		NSDate *stringTime = [NSDate dateWithNaturalLanguageString:entryTime];
		NSString *formattedDateStringTime = [timeFormatter stringFromDate:stringTime];
		
		int minutesRemaining = 0;
		if([hour intValue] == (int)nowHour && [minute intValue] > nowMinute) {
			minutesRemaining = [minute intValue] - (int)nowMinute;
		} else if([hour intValue] > (int)nowHour) {
			minutesRemaining = (60 - (int)nowMinute) + [minute intValue];
		}
		NSString *minutesRemainingString = [NSString stringWithFormat:@"%d", minutesRemaining];
		
		[timeEntryRows addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
															formattedDateStringTime, @"departureTime",
															cost, @"cost",
															minutesRemainingString, @"minutesRemaining",
															type, @"type",
															nil]];
	}
	
	[timeEntriesTableView reloadData];
	upcomingDeparturesLabel.text = @"Other Departures";
	[progressViewController.view	removeFromSuperview];
	
	if([entries count] > 0) {
		
		int count = [entries count];
		NSMutableDictionary *nextDeparture = nil;		
		int nextDepartureHour = 0;
		int nextDepartureMinute = 0;
		for(int i=0; i < count; i++) {
			nextDeparture = [entries objectAtIndex:i];
			nextDepartureHour = (int)[[nextDeparture objectForKey:@"hour"] intValue];
			nextDepartureMinute = (int)[[nextDeparture objectForKey:@"minute"] intValue];
			//NSLog(@"nextDepartureHour %d and nextDepartureMinute %d nowHour %d nowMinute %d", nextDepartureHour, nextDepartureMinute, nowHour, nowMinute);
			if(nextDepartureHour > nowHour || (nextDepartureHour == nowHour && nextDepartureMinute >= nowMinute) || (nowHour == 23 && nextDepartureHour == 0)) {
				break; // break out of loop when right time is fetched
			}
		}

		NSString *direction = (southbound == 1 ? @"Southbound" : @"Northbound");
		int minutesRemaining = 0;
		// more than hour out, set label, else show minutes countdown
		if(nextDepartureHour == nowHour && nextDepartureMinute >= nowMinute) {
			minutesRemaining = nextDepartureMinute - nowMinute;
			bigTime.textColor = [UIColor whiteColor];
			bigTimeHeaderText.text = [[NSString alloc] initWithFormat:@"Next %@ Departure", direction];
			bigTime.text = [[NSString alloc] initWithFormat:@"%d min", minutesRemaining];
			
		} else if(nextDepartureHour > nowHour) { // departure in the next hour
			minutesRemaining = (60 - nowMinute) + nextDepartureMinute;
			bigTime.textColor = [UIColor whiteColor];
			bigTimeHeaderText.text = [[NSString alloc] initWithFormat:@"Next %@ Departure", direction];
			bigTime.text = [[NSString alloc] initWithFormat:@"%d min", minutesRemaining];
		}
		
	} else { // ERROR handling, for some reason there were 0 or less departure times returned from the server
		bigTime.text = @"";
		bigTimeHeaderText.text = @"";
		upcomingDeparturesLabel.text = @"";
		[timeEntriesTableView reloadData];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No departure times found.\n\nTry changing the direction or tapping the refresh button." 
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


// Customize the appearance of table view cells.
// custom cells with interface builder http://icodeblog.com/2009/05/24/custom-uitableviewcell-using-interface-builder/
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
			[[cell type] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"type"]];
			[cell setBackgroundColor:[UIColor whiteColor]];
	
			minutes = [[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"minutesRemaining"] intValue];
			if(minutes < 6) {
				[cell	departureIcon].image = [UIImage imageNamed:@"exclamation.png"];
				[cell setBackgroundColor:[UIColor yellowColor]];
			} else {
				[cell	departureIcon].image = [UIImage imageNamed:@"clock.png"];
			}
			[[cell timeRemaining] setText:[[NSString alloc] initWithFormat:@"%d min", minutes]];
		}
		return cell;

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[timeEntryRows release];
	[responseData release];
	[railStationId release];
	[timeEntriesTableView release];
	[railStationId release];
	[railStationName release];
	[progressViewController release];
	[bigTimeHeaderText release];
	[bigTime release];
	[upcomingDeparturesLabel release];
	[super dealloc];
}


@end
