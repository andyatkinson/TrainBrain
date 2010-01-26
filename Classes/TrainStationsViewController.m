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

@synthesize stationsTableView, responseData, views, appDelegate;

- (void) loadTrainStations {
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Stops";
	
	// was passing lat/lng here lat=44.948364&lng=-93.239143
	NSString *requestURL = [NSString stringWithFormat:@"%@routes/%@/stops.json",
													[appDelegate getBaseUrl],
													[appDelegate getSelectedRouteId]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void)viewDidLoad {
	[super viewDidLoad];
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
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
	[stationsTableView reloadData];
	[HUD hide:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [stationsTableView indexPathForSelectedRow];
	if (selection) {
		[stationsTableView deselectRowAtIndexPath:selection animated:YES];
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
	
	CustomCell *cell = (CustomCell *)[stationsTableView dequeueReusableCellWithIdentifier:CellIdentifier];  
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TimeEntryViewController *targetViewController = (TimeEntryViewController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];	
				
	[appDelegate setSelectedStopId:[[views objectAtIndex:indexPath.row] objectForKey:@"stopId"]];
	[appDelegate setSelectedStopName:[[views objectAtIndex:indexPath.row] objectForKey:@"stationName"]];
	
	[[self navigationController] pushViewController:targetViewController animated:YES];	
}

- (void)hudWasHidden
{
}

- (void)dealloc {
    [super dealloc];
		[stationsTableView dealloc];
		[responseData dealloc];
		[views dealloc];
		[appDelegate dealloc];
}


@end
