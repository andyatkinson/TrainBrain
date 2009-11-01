//
//  LineHeadsignsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "LineHeadsignsViewController.h"
#import "JSON/JSON.h"

@implementation LineHeadsignsViewController

@synthesize headsignsTableView, responseData, views, progressViewController;

- (void) loadLineHeadsigns {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = [NSString stringWithFormat:@"Loading Headsigns for Line..."];
	self.progressViewController = pvc;
	[self.view addSubview:pvc.view];
	
	// TODO probably could instantiate/use a time entry object
	responseData = [[NSMutableData data] retain];
	

//	NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/rail_stations/%@/time_entries.json?t=%d:%d&s=%d", 
//																	[self railStationId],
//																	hour,
//																	minute,
//																	[self southbound]];
	
	NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/headsigns.json?lat=44.948364&lng=-93.239143&route_id=55-45"];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	
	// kick off the request, the view is reloaded from the request handler
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}



- (void)viewDidLoad {
	[super viewDidLoad];
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
			NSMutableDictionary *headsign = [headsigns objectAtIndex:i];
			
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												headsign, @"headsignName",
												nil]];			
			
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
	
	self.title = @"Headsigns";
	[progressViewController.view	removeFromSuperview];
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
}

- (void)dealloc {
    [super dealloc];
	[headsignsTableView dealloc];
}


@end
