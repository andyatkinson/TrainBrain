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
#import "Route.h"

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

//
// Hack to add 1px header/footer around tableview to prevent separator rows from showing
// See: http://stackoverflow.com/questions/1369831/eliminate-extra-separators-below-uitableview-in-iphone-sdk
// 
- (void) addHeaderAndFooter
{
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	v.backgroundColor = [UIColor clearColor];
	[self.routesTableView setTableHeaderView:v];
	[self.routesTableView setTableFooterView:v];
	[v release];
}

-(IBAction)refreshStations:(id)sender {
	[self loadRailStations];
}

- (void)viewDidLoad {
	// track state for Internet connection to avoid displaying alert multiple times
	HAS_INTERNET_CONNECTION = YES;
	
	// 231/231/231
	routesTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	routesTableView.separatorColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
	
	[super viewDidLoad];
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// prevent table view separator from showing on empty cells
	[self addHeaderAndFooter];
	
	
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
	if (HAS_INTERNET_CONNECTION == YES) {
		HAS_INTERNET_CONNECTION = NO;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network connection failed. \n\n Ensure Airplane Mode is not enabled and a network connection is available." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJSON *parser = [[SBJSON alloc] init];
	NSArray *records = [parser objectWithString:responseString error:nil];			
	
	[parser release];
	[responseString release];
	
	views = [[NSMutableArray alloc] init];	

	if ([records count] > 0) {
		for (id _record in records) {
			NSDictionary *_route = [_record objectForKey:@"route"];			
			Route *route = [[Route alloc] init];
			route.long_name = [_route objectForKey:@"route_long_name"];
			route.route_id = [_route objectForKey:@"route_id"];
			route.short_name = [_route objectForKey:@"route_short_name"];
			route.route_desc = [_route objectForKey:@"route_desc"];
			route.route_type = [_route objectForKey:@"route_type"];
			route.route_url = [_route objectForKey:@"route_url"];
			
			TrainStationsViewController *_controller = [[TrainStationsViewController alloc] init];
			[_controller setSelectedRoute:route];
			
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												_controller, @"controller",
												nil]];
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Routes Found." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[routesTableView reloadData];
	
	[HUD hide:YES];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil) {
		self.startingPoint = newLocation;
	}
	
	HUD.detailsLabelText = @"Routes";
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"%@train/v1/routes.json", [appDelegate getBaseUrl]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[locationString release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[HUD hide:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to acquire location." 
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
    
	static NSString *cellId = @"TrainLineCell";
	
	TrainLineCell *cell = (TrainLineCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TrainLineCell" owner:nil options:nil];
	
	for(id currentObject in nibObjects) {
		if([currentObject isKindOfClass:[TrainLineCell class]]) {
			cell = (TrainLineCell *)currentObject;
		}
	}
	
	if([views count] > 0) {
		Route *route = (Route *)[[[views objectAtIndex:indexPath.row] objectForKey:@"controller"] selectedRoute];

		[[cell lineTitle] setText:route.long_name];
		[[cell lineDescription] setText:route.short_name];
		[cell disclosureArrow].image = [UIImage imageNamed:@"icon_arrow.png"];
		
		if ([route.long_name rangeOfString:@"Hiawatha"].location == NSNotFound) {
			[cell lineImage].image = [UIImage imageNamed:@"icon_northstar.png"];
		} else {
			[cell lineImage].image = [UIImage imageNamed:@"icon_hiawatha.png"];
		}
		
		cell.backgroundView = [[[GradientView alloc] init] autorelease];
	}
	
	return cell;
}


// set the table view cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// do I need to set this if the height is specified in IB?
	return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TrainStationsViewController *targetViewController = (TrainStationsViewController *)[[views objectAtIndex:indexPath.row] objectForKey:@"controller"];
	[[self navigationController] pushViewController:targetViewController animated:YES];
	
}

- (void)hudWasHidden
{
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