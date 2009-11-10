//
//  LineHeadsignsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LineHeadsignsViewController.h"
#import "JSON/JSON.h"
#import "TimeEntryViewController.h"
#import "MapBarButtonItem.h"
#import "MapStopsViewController.h"

@implementation LineHeadsignsViewController

@synthesize headsignsTableView, responseData, views, progressViewController, appDelegate;

- (void) loadLineHeadsigns {
	progressViewController.message = [NSString stringWithFormat:@"Loading Headsigns for Line..."];
	[self.view addSubview:progressViewController.view];
	
	// TODO probably could instantiate/use a time entry object
	responseData = [[NSMutableData data] retain];
	
	NSString *requestURL = [NSString stringWithFormat:@"%@train_routes/%@/headsigns.json?lat=44.948364&lng=-93.239143",
													[appDelegate getBaseUrl],
													[appDelegate getSelectedRouteId]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	
	// kick off the request, the view is reloaded from the request handler
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void)viewDidLoad {
	[super viewDidLoad];
	progressViewController = [[ProgressViewController alloc] init];
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self loadLineHeadsigns];
	self.title = @"Lines";
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
	SBJSON *parser = [[SBJSON alloc] init];
	NSArray *headsigns = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	views = [[NSMutableArray alloc] init];
	
	int count = [headsigns count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSMutableDictionary *item = [headsigns objectAtIndex:i];
			TimeEntryViewController *timeEntryViewController = [[TimeEntryViewController alloc] init];
			
			NSString *headsign = [item objectForKey:@"headsign"];
			if(headsign != NULL) {
				NSLog(@"headsign %@", headsign);
				[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													headsign, @"headsignName",
													timeEntryViewController, @"controller",
													nil]];
			}
			
			NSMutableDictionary *stop = [item objectForKey:@"stop"];
			if(stop != NULL) {
				[appDelegate addStopId:[stop objectForKey:@"id"]];
			}
			
			[timeEntryViewController release];
			
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No headsigns Found.\n\nPlease try tapping the refresh button." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	// IMPORTANT: this call reloads the UITableView cells data after the data is available
	[headsignsTableView reloadData];
	
	self.title = @"Direction";
	[progressViewController.view	removeFromSuperview];
	[progressViewController stopProgressIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [headsignsTableView indexPathForSelectedRow];
	if (selection) {
		[headsignsTableView deselectRowAtIndexPath:selection animated:YES];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//return [[fetchedResultsController sections] count];
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	NSString *headsignName = [[views objectAtIndex:indexPath.row] objectForKey:@"headsignName"];
	NSLog(@"making cell %@", headsignName);
	cell.textLabel.text = headsignName;	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TimeEntryViewController *targetViewController = (TimeEntryViewController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];	
	
	MapBarButtonItem *temporaryBarButtonItem = [[MapBarButtonItem alloc] 
																							initWithTitle:@"Map" 
																							style:UIBarButtonItemStylePlain 
																							target:self 
																							action:@selector(mapButtonClicked:)];
	temporaryBarButtonItem.locationLat = [[NSString alloc] initWithFormat:@"%g", 47.2334];
	temporaryBarButtonItem.locationLng = [[NSString alloc] initWithFormat:@"%g", -37.234];
	temporaryBarButtonItem.stationLat = [[views objectAtIndex: indexPath.row] objectForKey:@"lat"];
	temporaryBarButtonItem.stationLng = [[views objectAtIndex: indexPath.row] objectForKey:@"lng"];
	targetViewController.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];	
	
	[appDelegate setHeadsign:[[views objectAtIndex: indexPath.row] objectForKey:@"headsignName"]];
	
	[[self navigationController] pushViewController:targetViewController animated:YES];
	
	
}

- (void)mapButtonClicked:(id)sender {
	NSLog(@"you clicked the map button!");

	MapStopsViewController *mapStops = [[MapStopsViewController alloc] init];
	[[self navigationController] pushViewController:mapStops animated:YES];
}

- (void)dealloc {
    [super dealloc];
	[headsignsTableView dealloc];
}


@end
