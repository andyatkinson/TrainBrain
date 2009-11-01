//
//  RootViewController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "RootViewController.h"
#import "TimeEntryController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"
#import "MapBarButtonItem.h"
#import "LineHeadsignsViewController.h"

@interface RootViewController (Private)
- (void)loadRailStations;
@end

@implementation RootViewController

@synthesize railStations, views, responseData, locationManager, startingPoint, progressViewController, 
linesTableView, southbound, directionControl, mapURL;

- (void) loadRailStations {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = @"Loading Train Lines...";
	self.progressViewController = pvc;
	[self.view addSubview:pvc.view];
	
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
	
	directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
	directionControl.tintColor = [UIColor darkGrayColor];
	directionControl.backgroundColor = [UIColor clearColor];
	
	[self loadRailStations];
	
	// TODO is this used?
	responseData = [[NSMutableData data] retain];
	
	//UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//	temporaryBarButtonItem.title = @"Stations";
//	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//	[temporaryBarButtonItem release];
	
	// set the title of the main navigation
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
			NSMutableDictionary *line = [lines objectAtIndex:i];
			LineHeadsignsViewController *lineHeadsignsViewController = [[LineHeadsignsViewController alloc] init];
			
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												line, @"lineName",
												lineHeadsignsViewController, @"controller",
												nil]];
			
//			TimeEntryController *timeEntryController = [[TimeEntryController alloc] init];
//			[timeEntryController setRailStationId:[station objectForKey:@"id"]]; // TODO should probably extract an object here
//			[timeEntryController setRailStationName:stationName];
//			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//												stationName, @"title",
//												timeEntryController, @"controller",
//												distance, @"distance",
//												lat, @"lat",
//												lng, @"lng",
//												nil]];
//			[timeEntryController release];
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
	
	self.title = @"Lines";
	// remove the modal view, now that the location has been calculated
	[progressViewController.view	removeFromSuperview];
}


// Location delegaate code TODO: should this be in another view controller?
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil)
		self.startingPoint = newLocation;
	
	NSString *newURL = @"http://localhost:3000/lines.json";
//	NSString *locationString = [[NSString alloc] initWithFormat:@"http://api.trainbrainapp.com/rail_stations.json?ll=%g,%g", 
//															newLocation.coordinate.latitude, 
//															newLocation.coordinate.longitude];
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"http://localhost:3000/lines.json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[locationString release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
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
    //return [[fetchedResultsController sections] count];
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
   
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}

	cell.textLabel.text = [[views objectAtIndex:indexPath.row] objectForKey:@"lineName"];
	
//	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
//	if (cell == nil) {  
//		cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];  
//	}  
//		
//	// Set up the cell...
//	cell.titleLabel.text = [[views objectAtIndex:indexPath.row] objectForKey:@"lineName"];
//	NSString *distanceString = [NSString stringWithFormat:@"%@", [[views objectAtIndex:indexPath.row] objectForKey:@"distance"]];
//	cell.distanceLabel.text = distanceString;

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//TimeEntryController *targetViewController = (TimeEntryController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];
	LineHeadsignsViewController *targetViewController = (LineHeadsignsViewController *)[[views objectAtIndex:indexPath.row] objectForKey:@"controller"];
	

	// Move this to Map view
	// add Map button, need to have ll coordinates set in parent view controller
//	MapBarButtonItem *temporaryBarButtonItem = [[MapBarButtonItem alloc] 
//																							initWithTitle:@"Map" 
//																							style:UIBarButtonItemStylePlain 
//																							target:self 
//																							action:@selector(mapButtonClicked:)];
//	temporaryBarButtonItem.locationLat = [[NSString alloc] initWithFormat:@"%g", startingPoint.coordinate.latitude];
//	temporaryBarButtonItem.locationLng = [[NSString alloc] initWithFormat:@"%g", startingPoint.coordinate.longitude];
//	temporaryBarButtonItem.stationLat = [[views objectAtIndex: indexPath.row] objectForKey:@"lat"];
//	temporaryBarButtonItem.stationLng = [[views objectAtIndex: indexPath.row] objectForKey:@"lng"];
//	targetViewController.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
//	[temporaryBarButtonItem release];	
	
	[[self navigationController] pushViewController:targetViewController animated:YES];
	
}

- (void) mapButtonClicked:(id)sender {	
	MapBarButtonItem *button = (MapBarButtonItem *)sender;
	//NSLog(@"sender locationLat %@ locationLng %@ stationLat %@ stationLng %@", button.locationLat, button.locationLat, button.stationLat, button.stationLng);
	mapURL = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%@,%@&daddr=%@,%@", button.locationLat, button.locationLng, button.stationLat, button.stationLng]; 
								
	// open the Maps application with a specific link
	UIAlertView *alert = [[UIAlertView alloc]  
												initWithTitle:@"Leave train brain and launch Maps application?"  
												message:nil  
												delegate:self  
												cancelButtonTitle:@"Cancel"  
												otherButtonTitles:@"OK", nil];  
	[alert show];  
	[alert release];  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{  
	if (buttonIndex == 1) {  
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapURL]];
	}  
	else {  
		// no-op Don't launch Maps app, stay within train brain
	}  
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