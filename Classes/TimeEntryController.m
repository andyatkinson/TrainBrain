//
//  TimeEntryController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeEntryController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"

// http://warm-sky-96.heroku.com/

@interface TimeEntryController (Private)
- (void) loadTimeEntries;
@end

@implementation TimeEntryController

@synthesize responseData, railStationId, railStationName, timeEntryRows, progressViewController, southbound, timeEntriesTableView, 
bigTime, bigTimeHeaderText, upcomingDeparturesLabel;

- (void)updateSouthbound:(NSInteger)newVal {
	self.southbound = newVal;
}

-(IBAction)refreshTimes:(id)sender {
	[self loadTimeEntries];
}

- (void) loadTimeEntries {
	
	self.progressViewController = [[ProgressViewController alloc] init];
	[self.view addSubview:progressViewController.view];

	// TODO probably could instantiate/use a time entry object
	responseData = [[NSMutableData data] retain];
	
	// get the hour and minute to send to server
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	int *hour = (int *)[components hour];
	NSLog(@"hour is %d", hour);
	
	components = [calendar components:NSMinuteCalendarUnit fromDate:now];
	int *minute = (int *)[components minute];
	NSLog(@"minute is %d", minute);
	
	// TODO get the UISegmentedControl value for setting north/south
	// Setting it from one view controller to another which is not a good solution	
	NSLog(@"got southbound true or false from parent: %d", [self southbound]);
	
	NSString *stationTimeEntries = [NSString stringWithFormat:@"http://localhost:3000/rail_stations/%@/time_entries.json?t=%d:%d&s=%d", 
																	[self railStationId],
																	hour,
																	minute,
																	[self southbound]];
	NSLog(@"making a request to URL: %@", stationTimeEntries);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stationTimeEntries]];
	
	timeEntryRows = nil;
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	// kick off the request, the view is reloaded from the request handler
}

// create a grouped style
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
	}
	return self;
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
	NSLog(@"Connection failed: %@", [error description]);  // remove me, consider adding label to UI
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	//[responseData release];  TODO should release here? don't think so
	
	SBJSON *parser = [[SBJSON alloc] init];
	// parse the JSON response into an object
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
	NSLog(@"nowHour %d nowMinute %d", nowHour, nowMinute);

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
		NSLog(@"Entry time %@", entryTime);		
		NSDate *stringTime = [NSDate dateWithNaturalLanguageString:entryTime];
		NSString *formattedDateStringTime = [timeFormatter stringFromDate:stringTime];
		NSLog(@"formattedDateStringTime: %@", formattedDateStringTime);
		
		int minutesRemaining = 61;
		if([hour intValue] == (int)nowHour && [minute intValue] > nowMinute) {
			minutesRemaining = [minute intValue] - (int)nowMinute;
			NSLog(@"Logging minutes remaining %d", minutesRemaining);
		}
		NSString *minutesRemainingString = [NSString stringWithFormat:@"%d", minutesRemaining];
		
		[timeEntryRows addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
															formattedDateStringTime, @"departureTime",
															cost, @"cost",
															minutesRemainingString, @"minutesRemaining",
															type, @"type",
															nil]];
	}
	
	// IMPORTANT: reloads table view cell data
	[timeEntriesTableView reloadData];
	
	[progressViewController.view	removeFromSuperview];
	
	if([entries count] > 0) {
		NSMutableDictionary *nextDeparture = [entries objectAtIndex:0];
		int nextDepartureHour = nil;
		int nextDepartureMinute = nil;
		nextDepartureHour = (int)[[nextDeparture objectForKey:@"hour"] intValue];
		nextDepartureMinute = (int)[[nextDeparture objectForKey:@"minute"] intValue];
		if(nextDepartureHour == nowHour && nextDepartureMinute <= nowMinute && [entries count] >= 2) {
			NSMutableDictionary *nextDeparture = [entries objectAtIndex:1];  // HACK HACK HACK, handle weird 10PM/11PM case
			nextDepartureHour = (int)[[nextDeparture objectForKey:@"hour"] intValue];
			nextDepartureMinute = (int)[[nextDeparture objectForKey:@"minute"] intValue];
		}
		
		NSLog(@"nowHour %d nowMinute %d", nowHour, nowMinute);
		NSLog(@"nextDepartureHour %d nextDepartureMinute %d", nextDepartureHour, nextDepartureMinute);
		
		// more than hour out, set label, else show minutes countdown
		if(nextDepartureHour == nowHour && nextDepartureMinute > nowMinute) {
			int minutesRemaining = nextDepartureMinute - nowMinute;
				
			if(0 < minutesRemaining < 60) {
				if(minutesRemaining <= 5) {
					bigTime.textColor = [UIColor redColor];
				} else {
					bigTime.textColor = [UIColor whiteColor];
				}
				
				bigTimeHeaderText.text = @"Minutes Until Next Departure";
				bigTime.text = [[NSString alloc] initWithFormat:@"%d", minutesRemaining];

			}
		} else { // more than 60 minutes out hour
			NSLog(@"-- No upcoming departures in next hour.");
			bigTimeHeaderText.text = @"Next Train Departs At";
			
			NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[timeFormatter setDateStyle:NSDateFormatterNoStyle];
			[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
			NSString *departureTime = [NSString stringWithFormat:@"%d:%d", nextDepartureHour, nextDepartureMinute];
			NSDate *stringTime = [NSDate dateWithNaturalLanguageString:departureTime];
			NSString *formattedDateStringTime = [timeFormatter stringFromDate:stringTime];
			NSLog(@"formattedDateStringTime: %@", formattedDateStringTime);
			bigTime.textColor = [UIColor whiteColor];
			bigTime.font = [UIFont systemFontOfSize:60];
			bigTime.text = formattedDateStringTime;
		}
	} else { // ERROR handling
		bigTime.text = @"";
		bigTimeHeaderText.text = @"";
		upcomingDeparturesLabel.text = @"";
		[timeEntriesTableView reloadData];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No departure times found.\n\nTry changing the direction or tapping the refresh button." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"Okay" 
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
	// return nil since label is static
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
			NSLog(@"minutes %d", minutes);
			if(minutes < 60) {
				if(minutes < 6) {
					[cell setBackgroundColor:[UIColor redColor]];
				}
				[[cell timeRemaining] setText:[[NSString alloc] initWithFormat:@"%d min", minutes]];
			} else {
				[[cell timeRemaining] setText:@""];
			}
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
	NSLog(@"View did unload!");
}


- (void)dealloc {
	[timeEntryRows release];
	[responseData release];
	[railStationId release];
	[timeEntriesTableView release];
	[responseData release];
	[railStationId release];
	[railStationName release];
	[timeEntryRows release];
	[progressViewController release];
	[southbound release];
	[bigTimeHeaderText release];
	[bigTime release];
	[upcomingDeparturesLabel release];
	[super dealloc];
}


@end
