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
	progressViewController.message = [NSString stringWithFormat:@"Loading Stops..."];
	[self.view addSubview:progressViewController.view];
	
	NSString *requestURL = [NSString stringWithFormat:@"%@stops.json", [appDelegate getBaseUrl]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	progressViewController = [[ProgressViewController alloc] init];
	appDelegate = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	responseData = [[NSMutableData data] retain];
	[self loadStops];
	[self setTitle:@"Train Stops"];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	NSLog(@"viewForAnnotation entered");
	MKAnnotationView *view = nil;
	if(annotation != mapView.userLocation) {
		StopAnnotation *stopAnn = (StopAnnotation *)annotation;
		view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"stopRouteId"];
		if(nil == view) {
			view = [[[MKPinAnnotationView alloc] initWithAnnotation:stopAnn
                                              reuseIdentifier:@"stopRouteId"] autorelease];
		}
		NSString *routeId = stopAnn.stop.routeId;
		NSLog(@"got route id %@", routeId);
		if(routeId == @"888-45") {
			[(MKPinAnnotationView *)view setPinColor:MKPinAnnotationColorRed];
		} else if(routeId == @"55-45") {
			[(MKPinAnnotationView *)view setPinColor:MKPinAnnotationColorPurple];
		} 
		[(MKPinAnnotationView *)view setAnimatesDrop:YES];
		[view setCanShowCallout:YES];
    [view setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
  }

	return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  //EarthquakeAnnotation *eqAnn = (EarthquakeAnnotation *)[view annotation];
  NSURL *url = [NSURL URLWithString:@"http://google.com"];
  [[UIApplication sharedApplication] openURL:url];
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
			[newStop setRouteId:[stop objectForKey:@"55-45"]];
			
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
	[progressViewController stopProgressIndicator];
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
