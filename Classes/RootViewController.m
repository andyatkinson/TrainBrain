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
#import "TrainStationsViewController.h"
#import "MapStopsViewController.h"

@interface RootViewController (Private)
- (void)loadRailStations;
@end

@implementation RootViewController

@synthesize views, responseData, locationManager, startingPoint, routesTableView, appDelegate;

- (void) loadRailStations {
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Location";
	[HUD show:YES];
	
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
}

-(IBAction)refreshStations:(id)sender {
	[self loadRailStations];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshStations:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];	
	[self loadRailStations];
	responseData = [[NSMutableData data] retain];
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
			TrainStationsViewController *trainStationsViewController = [[TrainStationsViewController alloc] init];
			
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												routeId, @"route_id",
												shortName, @"short_name",
												longName, @"long_name",
												trainStationsViewController, @"controller",
												nil]];
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Routes Found.\n\nPlease try tapping the refresh button." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	// IMPORTANT: this call reloads the UITableView cells data after the data is available
	[routesTableView reloadData];
	
	[HUD hide:YES];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil) {
		self.startingPoint = newLocation;
	}
	
	HUD.detailsLabelText = @"Routes";
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"%@routes.json", [appDelegate getBaseUrl]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[locationString release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[HUD hide:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Train Brain failed to access your location." 
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
	NSIndexPath*	selection = [routesTableView indexPathForSelectedRow];
	if (selection) {
		[routesTableView deselectRowAtIndexPath:selection animated:YES];
	}
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
		
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	NSString *longName = [NSString stringWithFormat:@"%@", [[views objectAtIndex:indexPath.row] objectForKey:@"long_name"]];
	NSString *shortName = [[views objectAtIndex:indexPath.row] objectForKey:@"short_name"];
	cell.titleLabel.text = longName;
	cell.distanceLabel.text = [NSString stringWithFormat:@"%@", shortName];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TrainStationsViewController *targetViewController = (TrainStationsViewController *)[[views objectAtIndex:indexPath.row] objectForKey:@"controller"];
	[appDelegate setSelectedRouteId:[[views objectAtIndex:indexPath.row] objectForKey:@"route_id"]];	
	[[self navigationController] pushViewController:targetViewController animated:YES];
	
}

- (void)dealloc {
	[views release];
	[locationManager release];
	[startingPoint release];
	[routesTableView release];
	[responseData release];
	[super dealloc];
}

@end