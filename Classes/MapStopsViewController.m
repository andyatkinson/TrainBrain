//
//  MapStopsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapStopsViewController.h"
#import "JSON/JSON.h"
#import "Stop.h"
#import "StopAnnotation.h"

@implementation MapStopsViewController

@synthesize mapView, progressViewController, responseData;

- (void) loadStops {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = [NSString stringWithFormat:@"Loading Stops..."];
	self.progressViewController = pvc;
	[self.view addSubview:pvc.view];
	
	responseData = [[NSMutableData data] retain];
	
	NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/all_stops.json"];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	
	// kick off the request, the view is reloaded from the request handler
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self loadStops];
	
	[self setTitle:@"Stops"];
	
	// load the current station
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
	NSArray *stops = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	
	int count = [stops count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSDictionary *stop = [[stops objectAtIndex:i] objectForKey:@"stop"];
			
			Stop *newStop = [[Stop alloc] init];
			
			[newStop setStopName:[stop objectForKey:@"name"]];
			[newStop setStreet:[stop objectForKey:@"street"]];
			[newStop setDescription:[stop objectForKey:@"description"]];
			
			NSNumber *stopLat = [stop objectForKey:@"stop_lat"];
			NSNumber *stopLon = [stop objectForKey:@"stop_lon"];
			CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:stopLat.floatValue longitude:stopLon.floatValue];
	
			[newStop setLocation:stopLocation];
			[stopLocation release];

			StopAnnotation *stopAnnotation = [StopAnnotation annotationWithStop:newStop];
			[self.mapView addAnnotation:stopAnnotation];
			
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
	
	[progressViewController.view	removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.

}

-(IBAction)toggleMapStopsView:(id)sender {
	NSLog(@"toggle the view");
	
	
	
	// make the web call and load all the stations
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
