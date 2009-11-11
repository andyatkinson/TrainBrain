//
//  TrainStationsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrainStationsViewController.h"
#import "JSON/JSON.h"
#import "TimeEntryViewController.h"

@implementation TrainStationsViewController

@synthesize tableView, responseData, views, progressViewController, appDelegate;

- (void) loadTrainStations {
	progressViewController.message = [NSString stringWithFormat:@"Loading Stations for Route..."];
	[self.view addSubview:progressViewController.view];
	[progressViewController startProgressIndicator];
	
	NSString *requestURL = [NSString stringWithFormat:@"%@train_stations/%@.json?lat=44.948364&lng=-93.239143",
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
	responseData = [[NSMutableData data] retain];
	[self loadTrainStations];
	self.title = @"Stops";
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
	NSArray *trainStations = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	views = [[NSMutableArray alloc] init];
	
	int count = [trainStations count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSMutableDictionary *item = [trainStations objectAtIndex:i];
			TimeEntryViewController *targetViewController = [[TimeEntryViewController alloc] init];
			
			NSString *stationName = [[item objectForKey:@"train_station"] objectForKey:@"name"];
			NSString *stationDescription = [[item objectForKey:@"train_station"] objectForKey:@"description"];
			NSString *stationStreet = [[item objectForKey:@"train_station"] objectForKey:@"street"];
			NSString *stopId = [[item objectForKey:@"train_station"] objectForKey:@"stop_id"];
			if(stopId != NULL) {
				[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													stopId, @"stopId",
													stationName, @"stationName",
													stationDescription, @"stationDescription",
													stationStreet, @"stationStreet",
													targetViewController, @"controller",
													nil]];
			}
			
			[targetViewController release];
			
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Stops Found." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	// IMPORTANT: this call reloads the UITableView cells data after the data is available
	[tableView reloadData];
			
	[progressViewController.view	removeFromSuperview];
	[progressViewController stopProgressIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [tableView indexPathForSelectedRow];
	if (selection) {
		[tableView deselectRowAtIndexPath:selection animated:YES];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
	if (cell == nil) {  
		cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}  
	
	// Set up the cell...
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	cell.titleLabel.text = [[views objectAtIndex:indexPath.row] objectForKey:@"stationName"];
	NSString *description = [NSString stringWithFormat:@"%@ at %@", 
													 [[views objectAtIndex:indexPath.row] objectForKey:@"stationDescription"],
													 [[views objectAtIndex:indexPath.row] objectForKey:@"stationStreet"]];
	cell.distanceLabel.text = description;
	
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
				
	[appDelegate setSelectedStopId:[[views objectAtIndex:indexPath.row] objectForKey:@"stopId"]];
	[appDelegate setSelectedStopName:[[views objectAtIndex:indexPath.row] objectForKey:@"stationName"]];
	
	[[self navigationController] pushViewController:targetViewController animated:YES];	
}

- (void)dealloc {
    [super dealloc];
		[tableView dealloc];
}


@end
