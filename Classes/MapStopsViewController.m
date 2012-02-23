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

@synthesize stops, mapView, route_id;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)loadStops {
  NSString *requestURL = [NSString stringWithFormat:@"train/v1/routes/%@/stops/all", self.route_id];
  
  [Stop stopsWithURLString:requestURL near:nil parameters:nil block:^(NSArray *records) {
    
    [HUD hide:YES];
    self.stops = records;
    [self displayMapData];
    
  }];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
		
	[super viewDidLoad];
  
  HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"Stops";
	[HUD show:YES];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	[self loadStops];
	self.title = @"Map";
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


- (void)displayMapData {
  
  for (id _stop in self.stops) {
    Stop *stop = (Stop*)_stop;
    StopAnnotation *annotation = [StopAnnotation annotationWithStop:stop];
    [self.mapView addAnnotation:annotation];			
    
    [stop release];
    [annotation release];
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


- (void)dealloc {
	[super dealloc];
	[mapView dealloc];
}


@end
