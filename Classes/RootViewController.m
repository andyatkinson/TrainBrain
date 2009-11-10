//
//  RootViewController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "RootViewController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"
#import "MapBarButtonItem.h"
#import "LineHeadsignsViewController.h"

@interface RootViewController (Private)
- (void)loadRailStations;
@end

@implementation RootViewController

@synthesize railStations, views, responseData, locationManager, startingPoint, progressViewController, 
linesTableView, southbound, directionControl, mapURL, appDelegate;

- (void) loadRailStations {
	progressViewController.message = @"Loading Train Routes...";
	[self.view addSubview:progressViewController.view];
	
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
	
	// kick off the request, the view is reloaded from the location update code
}

-(IBAction)refreshStations:(id)sender {
	[self loadRailStations];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	progressViewController = [[ProgressViewController alloc] init];
	
	directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
	directionControl.tintColor = [UIColor darkGrayColor];
	directionControl.backgroundColor = [UIColor clearColor];
	
	[self loadRailStations];
	
	// TODO is this used?
	responseData = [[NSMutableData data] retain];

	self.title = @"train brain";
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
	// parse the JSON response into an object
	NSArray *lines = [parser objectWithString:responseString error:nil];			
	[parser release];
	[responseString release];
	views = [[NSMutableArray alloc] init];
	int count = [lines count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSMutableDictionary *line = [[lines objectAtIndex:i] objectForKey:@"route"];
			NSString *routeId = [line objectForKey:@"route_id"];
			NSString *shortName = [line objectForKey:@"short_name"];
			NSString *longName = [line objectForKey:@"long_name"];
			LineHeadsignsViewController *lineHeadsignsViewController = [[LineHeadsignsViewController alloc] init];
			
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												routeId, @"route_id",
												shortName, @"short_name",
												longName, @"long_name",
												lineHeadsignsViewController, @"controller",
												nil]];
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Stations Found.\n\nPlease try tapping the refresh button." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	// IMPORTANT: this call reloads the UITableView cells data after the data is available
	[linesTableView reloadData];
	
	self.title = @"Train Routes";
	// remove the modal view, now that the location has been calculated
	[progressViewController.view	removeFromSuperview];	
	[progressViewController stopProgressIndicator];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil) {
		self.startingPoint = newLocation;
	}
	
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"%@train_routes.json", [appDelegate getBaseUrl]];
	NSLog(@"got location string %@", locationString);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[locationString release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
	[progressViewController stopProgressIndicator];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Train Brain requires location data to display train stations sorted by distance." 
																									message:nil 
																								 delegate:nil 
																				cancelButtonTitle:@"OK" 
																				otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [linesTableView indexPathForSelectedRow];
	if (selection) {
		[linesTableView deselectRowAtIndexPath:selection animated:YES];
	}
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
	if (cell == nil) {  
		cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];  
	}  
		
	// Set up the cell...
	cell.titleLabel.text = [[views objectAtIndex:indexPath.row] objectForKey:@"short_name"];
	NSString *longName = [NSString stringWithFormat:@"%@", [[views objectAtIndex:indexPath.row] objectForKey:@"long_name"]];
	cell.distanceLabel.text = longName;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LineHeadsignsViewController *targetViewController = (LineHeadsignsViewController *)[[views objectAtIndex:indexPath.row] objectForKey:@"controller"];
	
	[appDelegate setSelectedRouteId:[[views objectAtIndex:indexPath.row] objectForKey:@"route_id"]];
	
	[[self navigationController] pushViewController:targetViewController animated:YES];
	
}

- (void)dealloc {
	[views release];
	[locationManager release];
	[startingPoint release];
	[progressViewController release];
	[linesTableView release];
	[railStations release];
	[responseData release];
	[super dealloc];
}

@end