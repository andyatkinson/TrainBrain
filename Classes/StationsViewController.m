//
//  StationsViewController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "StationsViewController.h"
#import "TimeEntryController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"
#import "MapBarButtonItem.h"

@interface StationsViewController (Private)
- (void)loadRailStations;
@end

@implementation StationsViewController

@synthesize railStations, views, responseData, locationManager, startingPoint, progressViewController, 
				stationsTableView, southbound, directionControl, mapURL;

- (void) loadRailStations {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = @"Loading Train Stations...";
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
//	[super viewDidLoad];
//	
//	directionControl.segmentedControlStyle = UISegmentedControlStyleBar;
//	directionControl.tintColor = [UIColor darkGrayColor];
//	directionControl.backgroundColor = [UIColor clearColor];
//	
//	[self loadRailStations];
//	
//	// TODO is this used?
//	responseData = [[NSMutableData data] retain];
//	
//	// Set the Stations back button
//	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//	temporaryBarButtonItem.title = @"Stations";
//	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//	[temporaryBarButtonItem release];
//	
//	// set the title of the main navigation
//	self.title = @"train brain";
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
	NSArray *stations = [parser objectWithString:responseString error:nil];			
	[parser release];
	[responseString release];
	views = [[NSMutableArray alloc] init];
	int count = [stations count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSMutableDictionary *station = [stations objectAtIndex:i];
			NSString *stationName = [station objectForKey:@"name"];
			NSString *distance = [station objectForKey:@"distance"];
			NSString *lat = [station objectForKey:@"lat"];
			NSString *lng = [station objectForKey:@"lng"];
			TimeEntryController *timeEntryController = [[TimeEntryController alloc] init];
			[timeEntryController setRailStationId:[station objectForKey:@"id"]]; // TODO should probably extract an object here
			[timeEntryController setRailStationName:stationName];
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												stationName, @"title",
												timeEntryController, @"controller",
												distance, @"distance",
												lat, @"lat",
												lng, @"lng",
												nil]];
			[timeEntryController release];
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
	[stationsTableView reloadData];
	
	self.title = @"Tap a departure Station";
	// remove the modal view, now that the location has been calculated
	[progressViewController.view	removeFromSuperview];
}


// Location delegaate code TODO: should this be in another view controller?
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil)
		self.startingPoint = newLocation;
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"http://localhost:3000/rail_stations.json?ll=%g,%g", 
															newLocation.coordinate.latitude, 
															newLocation.coordinate.longitude];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[locationString release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"train brain requires location data to display train stations sorted by distance." 
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
	NSIndexPath*	selection = [stationsTableView indexPathForSelectedRow];
	if (selection) {
		[stationsTableView deselectRowAtIndexPath:selection animated:YES];
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
	cell.titleLabel.text = [[views objectAtIndex:indexPath.row] objectForKey:@"title"];
	NSString *distanceString = [NSString stringWithFormat:@"%@", [[views objectAtIndex:indexPath.row] objectForKey:@"distance"]];
	cell.distanceLabel.text = distanceString;

	return cell;
}

- (void)updateSouthbound:(NSInteger)newVal {
	self.southbound = newVal;
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	// Navigation logic may go here -- for example, create and push another view controller.	
	TimeEntryController *targetViewController = (TimeEntryController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];
	
	if([self southbound] == 0 && [[targetViewController railStationName] isEqualToString:@"Warehouse District/Hennepin Avenue Station"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This station does not have Northbound departures.\n\nSelect Southbound or choose another station." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self viewWillAppear:TRUE];
	} else if([self southbound] == 1 && [[targetViewController railStationName] isEqualToString:@"Mall of America Station"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This station does not have Southbound departures.\n\nSelect Northbound or choose another station.." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self viewWillAppear:TRUE];
  } else {
		
		// trying a crazy hack to read the value of StationsViewController.southbound and set it on TimeEntryController.southbound
		// maybe need a Singleton pattern here but couldn't figure it out TODO FIXME
		[targetViewController setSouthbound:[self southbound]];
		
		// add Map button, need to have ll coordinates set in parent view controller
		MapBarButtonItem *temporaryBarButtonItem = [[MapBarButtonItem alloc] 
																										 initWithTitle:@"Map" 
																										 style:UIBarButtonItemStylePlain 
																										 target:self 
																										 action:@selector(mapButtonClicked:)];
		temporaryBarButtonItem.locationLat = [[NSString alloc] initWithFormat:@"%g", startingPoint.coordinate.latitude];
		temporaryBarButtonItem.locationLng = [[NSString alloc] initWithFormat:@"%g", startingPoint.coordinate.longitude];
		temporaryBarButtonItem.stationLat = [[views objectAtIndex: indexPath.row] objectForKey:@"lat"];
		temporaryBarButtonItem.stationLng = [[views objectAtIndex: indexPath.row] objectForKey:@"lng"];
		targetViewController.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
		[temporaryBarButtonItem release];
		
		//[[self navigationController] pushViewController:targetViewController animated:YES];

	}
}

- (void) mapButtonClicked:(id)sender {	
	MapBarButtonItem *button = (MapBarButtonItem *)sender;
	// old URL mapURL = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%@,%@&daddr=%@,%@", button.locationLat, button.locationLng, button.stationLat, button.stationLng]; 

	MapViewController *mapViewController = [[MapViewController alloc] init];
	mapViewController.stationLatitude = button.stationLat;
	mapViewController.stationLongitude = button.stationLng;
	

	//[[self navigationController] pushViewController:mapViewController animated:YES];
	
	
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

- (IBAction)toggleDirection:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSInteger segment = segmentedControl.selectedSegmentIndex;
	[self updateSouthbound:segment];
}

- (void)dealloc {
	[views release];
	[locationManager release];
	[startingPoint release];
	[progressViewController release];
	[stationsTableView release];
	[railStations release];
	[responseData release];
	[super dealloc];
}

@end