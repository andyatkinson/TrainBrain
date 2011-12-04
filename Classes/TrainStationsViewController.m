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
#import "Stop.h"

@implementation TrainStationsViewController

@synthesize stationsTableView, responseData, views, appDelegate, selectedRoute;

- (void) loadTrainStations {
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Stations";
	
	// was passing lat/lng here lat=44.948364&lng=-93.239143
	NSString *requestURL = [NSString stringWithFormat:@"%@train/v1/routes/%@/stops.json",
													[appDelegate getBaseUrl],
													selectedRoute.route_id];
	NSLog(@"request URL: %@", requestURL);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//
// Hack to add 1px header/footer around tableview to prevent separator rows from showing
// See: http://stackoverflow.com/questions/1369831/eliminate-extra-separators-below-uitableview-in-iphone-sdk
// 
- (void) addHeaderAndFooter
{
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	v.backgroundColor = [UIColor clearColor];
	[self.stationsTableView setTableHeaderView:v];
	[self.stationsTableView setTableFooterView:v];
	[v release];
}


- (void)viewDidLoad {
	// 231/231/231
	stationsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	stationsTableView.separatorColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
	
	// prevent table view separator from showing on empty cells
	[self addHeaderAndFooter];
	
	[super viewDidLoad];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	responseData = [[NSMutableData data] retain];
	[self loadTrainStations];
	self.title = selectedRoute.long_name;
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
	NSArray *records = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	
	views = [[NSMutableArray alloc] init];
	
	if ([records count] > 0) {
		for (id _record in records) {
			NSDictionary *_stop = [_record objectForKey:@"stop"];
			Stop *stop = [[Stop alloc] init];
			stop.stop_name = [_stop objectForKey:@"stop_name"];
			stop.stop_id = [_stop objectForKey:@"stop_id"];
			stop.stop_desc = [_stop objectForKey:@"stop_desc"];
			
			TimeEntryViewController *_controller = [[TimeEntryViewController alloc] init];
			[_controller setSelectedStop:stop];
			[_controller setSelectedRoute:selectedRoute];
			
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												_controller, @"controller",
												nil]];
			
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
	
	static NSString *cellId = @"StationCell";
	
	StationCell *cell = (StationCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"StationCell" owner:nil options:nil];
	
	for(id currentObject in nibObjects) {
		if([currentObject isKindOfClass:[StationCell class]]) {
			cell = (StationCell *)currentObject;
		}
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	Stop *stop = (Stop *)[[[views objectAtIndex:indexPath.row] objectForKey:@"controller"] selectedStop];
	cell.stationName.text = stop.stop_name;
	cell.stationDescription.text = stop.stop_desc;
	cell.backgroundView = [[[GradientView alloc] init] autorelease];
	return cell;
}


// set the table view cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// what should it be really?
	return 56;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TimeEntryViewController *controller = (TimeEntryViewController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];
	[controller setSelectedStop:controller.selectedStop];
	[controller setSelectedRoute:controller.selectedRoute];
	
	[[self navigationController] pushViewController:controller animated:YES];
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
