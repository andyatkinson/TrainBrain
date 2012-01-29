//
//  MapStopsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "MapStopsViewController.h"
#import "JSON/JSON.h"
#import "Stop.h"
#import "StopAnnotation.h"

@implementation MapStopsViewController

@synthesize responseData, appDelegate, mapView, route_id;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void) loadStops {
	NSLog(@"load stops called!");
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Stops";
	[HUD show:YES];
	
	NSString *requestURL = [NSString stringWithFormat:@"%@train/v1/maps.json?route_id=%@", [appDelegate getBaseUrl], self.route_id];
	NSLog(@"request URL: %@", requestURL);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
		
	[super viewDidLoad];
	appDelegate = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	responseData = [[NSMutableData data] retain];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	[self loadStops];
	self.title = @"Map";
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
  MKAnnotationView *view = nil;
	if (annotation != mapView.userLocation) {
		StopAnnotation *stopAnnotation = (StopAnnotation *)annotation;
		view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"stopRouteId"];
		

//		if (nil == view) {
//			NSString *route_id = stopAnnotation.stop.routeId;
//			NSRange hiawathaRange = [routeId rangeOfString:@"55"];
//			NSRange northstarRange = [routeId rangeOfString:@"888"];
//			if (hiawathaRange.location != NSNotFound) {
//				view = [[[CustomPinBlack alloc] initWithAnnotation:annotation] autorelease];
//			} else if(northstarRange.location != NSNotFound) {
//				view = [[[CustomPinBlue alloc] initWithAnnotation:annotation] autorelease];
//			}
		//}

		[(MKPinAnnotationView *)view setAnimatesDrop:NO];
		 
		[view setCanShowCallout:YES];
		[view setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
	}

	return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	NSLog(@"callout accessory tapped, load the time entry view");
	StopAnnotation *stopAnn = (StopAnnotation *)[view annotation];

	//NSURL *webUrl = [NSURL URLWithString:stopAnn.stop.webUrl];
//  [[UIApplication sharedApplication] openURL:webUrl];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Map data is not available." 
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
	
	if ([records count] > 0) {
		for (id _record in records) {
			
			NSDictionary *_stop = [_record objectForKey:@"stop"];			
			Stop *stop = [[Stop alloc] init];
			stop.stop_name = [_stop objectForKey:@"stop_name"];
			stop.stop_street = [_stop objectForKey:@"stop_street"];
			stop.stop_id = [_stop objectForKey:@"stop_id"];
			stop.stop_desc = [_stop objectForKey:@"stop_desc"];
			stop.stop_lat = [_stop objectForKey:@"stop_lat"];
			stop.stop_lon = [_stop objectForKey:@"stop_lon"];
			
			CLLocation *location = [[CLLocation alloc] initWithLatitude:stop.stop_lat.floatValue longitude:stop.stop_lon.floatValue];
			stop.location = location;

			[location release];
			
			StopAnnotation *annotation = [StopAnnotation annotationWithStop:stop];
			[self.mapView addAnnotation:annotation];
			
			[stop release];
			[annotation release];
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
	
	[self recenterMap];
	[HUD hide:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)hudWasHidden
{
}


- (void)dealloc {
	[super dealloc];
	[mapView dealloc];
	[responseData dealloc];
	[appDelegate dealloc];
}


@end
