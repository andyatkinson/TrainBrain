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

@synthesize mapView, progressViewController, responseData, appDelegate;

- (void) loadStops {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = [NSString stringWithFormat:@"Loading Stops..."];
	self.progressViewController = pvc;
	[self.view addSubview:pvc.view];
	
	NSString *requestURL = [NSString stringWithFormat:@"http://localhost:3000/stops.json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	responseData = [[NSMutableData data] retain];
	[self loadStops];
	[self setTitle:@"Train Stops"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"receiging response");
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"receiving data");
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

- (void)recenterMap {
	NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
	CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
	CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
	for(NSValue *value in coordinates) {
		CLLocationCoordinate2D coord = {0.0f, 0.0f};
		[value getValue:&coord];
		if(coord.longitude > maxCoord.longitude) {
			maxCoord.longitude = coord.longitude;
		}
		if(coord.latitude > maxCoord.latitude) {
			maxCoord.latitude = coord.latitude;
		}
		if(coord.longitude < minCoord.longitude) {
			minCoord.longitude = coord.longitude;
		}
		if(coord.latitude < minCoord.latitude) {
			minCoord.latitude = coord.latitude;
		}
	}
	MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
	region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
	region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
	region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
	region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
	[self.mapView setRegion:region animated:YES];  
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"got response %@", responseString);
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
	[self recenterMap];
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


- (void)dealloc {
    [super dealloc];
}


@end
