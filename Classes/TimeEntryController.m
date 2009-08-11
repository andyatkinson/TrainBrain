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

@synthesize responseData, railStationId, railStationName, timeEntryRows, progressViewController, southbound, timeEntriesTableView, bigTime, nextTime, bigTimeHeaderText;

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
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	// kick off the request, the view is reloaded from the request handler
}

// create a grouped style
- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	timeEntriesTableView.backgroundColor = [UIColor clearColor];
	
	[self loadTimeEntries];

	
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


- (void) onTimer:(NSTimer*)theTimer {
	bigTime.textColor = [UIColor whiteColor];
	NSInteger *time = (NSInteger *)([self nextTime] - 1);
	NSLog(@"logged start time %d", time);
	[self setNextTime:time];
	NSString *theTime = [[NSString alloc] initWithFormat:@"%d mins", time];
	if(time > 0) {
		bigTime.text = theTime;
	}
	[theTimer invalidate];
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
	int *nowHour = (int *)[components hour];
	components = [calendar components:NSMinuteCalendarUnit fromDate:now];
	int *nowMinute = (int *)[components minute];
	NSLog(@"nowHour %d nowMinute %d", nowHour, nowMinute);

	timeEntryRows = [[NSMutableArray alloc] init];
	
	int count = [entries count];
	for(int i=0; i < count; i++) {
		NSMutableDictionary *entry = [entries objectAtIndex:i];
		NSString *hour = [entry objectForKey:@"hour"];
		NSString *minute = [entry objectForKey:@"minute"];
		NSString *cost = [entry objectForKey:@"cost"];
		
		NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		NSString *entryTime = [NSString stringWithFormat:@"%@:%@", hour, minute];
		NSLog(@"Entry time %@", entryTime);		
		NSDate *stringTime = [NSDate dateWithNaturalLanguageString:entryTime];
		NSString *formattedDateStringTime = [timeFormatter stringFromDate:stringTime];
		NSLog(@"formattedDateStringTime: %@", formattedDateStringTime);
		
		// minute should never be less than nowMinute, server shouldn't send anything back that is older
		int minutesRemaining = 61;
		if([hour intValue] == (int)nowHour) {
			minutesRemaining = [minute intValue] - (int)nowMinute;
			NSLog(@"Logging minutes remaining %d", minutesRemaining);
		}
		NSString *minutesRemainingString = [NSString stringWithFormat:@"%d", minutesRemaining];
		
		[timeEntryRows addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
															formattedDateStringTime, @"departureTime",
															cost, @"cost",
															minutesRemainingString, @"minutesRemaining",
															nil]];
	}
	
	// IMPORTANT: reloads table view cell data
	[timeEntriesTableView reloadData];
	
	// remove the progress view
	[progressViewController.view	removeFromSuperview];
	
	// get the first item from the array
	if([entries count] > 0) {
		NSMutableDictionary *nextDeparture = [entries objectAtIndex:0];
		int *nextDepartureHour = (int *)[[nextDeparture objectForKey:@"hour"] intValue];
		int *nextDepartureMinute = (int *)[[nextDeparture objectForKey:@"minute"] intValue];
		NSLog(@"nextDepartureHour %d nextDepartureMinute %d", nextDepartureHour, nextDepartureMinute);
		// e.g. currentTime 11:10 nextDeparture 11:21 => "11..10..9...1..NOW"
		// more than hour out, set label, else show minutes countdown
		if(nextDepartureHour == nowHour && nextDepartureMinute > nowMinute) {
			int minutesRemaining = nextDepartureMinute - nowMinute;
			[self setNextTime:minutesRemaining];
			[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
		} else {
			bigTime.text = @"4:30";
		}
	}
}


// table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Upcoming Departures";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [timeEntryRows count];
}


// Customize the appearance of table view cells.
// custom cells with interface builder http://icodeblog.com/2009/05/24/custom-uitableviewcell-using-interface-builder/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"DepartureDetailCell";
	DepartureDetailCell *cell = (DepartureDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == NULL) {  
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DepartureDetailCell" owner:nil options:nil];
		
		for(id currrentObject in nibObjects) {
			if([currrentObject isKindOfClass:[DepartureDetailCell class]]) {
				cell = (DepartureDetailCell *)currrentObject;
			}
		}
	
		if([timeEntryRows count] > 0) {
			[cell setBackgroundColor:[UIColor redColor]];
			[[cell departureTime] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"departureTime"]];
			[[cell departureCost] setText:[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"cost"]];
	
			int minutes = [[[timeEntryRows objectAtIndex:indexPath.row] objectForKey:@"minutesRemaining"] intValue];
			NSLog(@"minutes %d", minutes);
//			if(minutes > 60) {
//				[[cell timeRemaining] setText:@"> 1 hour"];
//			} else {
//				[[cell timeRemaining] setTextColor:[UIColor blackColor]];
//				if(minutes <= 5){
//					[[cell timeRemaining] setTextColor:[UIColor redColor]];
//				}
//				[[cell timeRemaining] setText:minutes];
//			}
		}
		return cell;
	}
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
	[super dealloc];
}


@end
