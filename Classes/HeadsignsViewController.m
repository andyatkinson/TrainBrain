//
//  HeadsignsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 11/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HeadsignsViewController.h"
#import "JSON/JSON.h"
#import "TimeEntryViewController.h"
#import "MapStopsViewController.h"

@implementation HeadsignsViewController

@synthesize tableView, responseData, views, progressViewController, appDelegate;

- (void) loadHeadsigns {
	progressViewController.message = [NSString stringWithFormat:@"Loading Headsigns for Station..."];
	[self.view addSubview:progressViewController.view];
	[progressViewController startProgressIndicator];
	
	NSString *requestURL = [NSString stringWithFormat:@"%@train_routes/%@/headsigns.json",
													[appDelegate getBaseUrl],
													[appDelegate getSelectedRouteId]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	
	// kick off the request, the view is reloaded from the request handler
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	responseData = [[NSMutableData data] retain];
	progressViewController = [[ProgressViewController alloc] init];
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];	
	[self loadHeadsigns];
	self.title = @"Choose Direction";
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
			NSMutableDictionary *headsignName = [headsigns objectAtIndex:i];
			TimeEntryViewController *timeEntryViewController = [[TimeEntryViewController alloc] init];

			if(headsignName != NULL) {
				[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
													headsignName, @"headsignName",
													timeEntryViewController, @"controller",
													nil]];
			}
			
			[timeEntryViewController release];
			
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Headsigns Found." 
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}


- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [tableView indexPathForSelectedRow];
	if (selection) {
		[tableView deselectRowAtIndexPath:selection animated:YES];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	NSString *headsignName = [[views objectAtIndex:indexPath.row] objectForKey:@"headsignName"];
	NSLog(@"headsign text %@", headsignName);
	cell.textLabel.text = headsignName;	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TimeEntryViewController *targetViewController = (TimeEntryViewController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];	
	
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonClicked:)];
	targetViewController.navigationItem.rightBarButtonItem = mapButton;
	[mapButton release];
	
	[appDelegate setSelectedHeadsign:[[views objectAtIndex:indexPath.row] objectForKey:@"headsignName"]];
	
	[[self navigationController] pushViewController:targetViewController animated:YES];	
}


- (void)mapButtonClicked:(id)sender {
	MapStopsViewController *mapStops = [[MapStopsViewController alloc] init];
	[[self navigationController] pushViewController:mapStops animated:YES];
}


- (void)dealloc {
    [super dealloc];
	[tableView release];
}


@end

