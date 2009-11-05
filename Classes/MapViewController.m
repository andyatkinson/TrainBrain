//
//  MapViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 9/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize currentStopLat, currentStopLng;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	[mapView setShowsUserLocation:YES];
	
	mapView.delegate = self;
	
	/*Region and Zoom*/
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.05;
	span.longitudeDelta = 0.05;
	
	CLLocationCoordinate2D location = mapView.userLocation.coordinate;
	
	location.latitude = [currentStopLat floatValue];
	location.longitude = [currentStopLng floatValue];
	region.span = span;
	region.center = location;
	
	geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:location];
	geoCoder.delegate = self;
	[geoCoder start];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	
	[self.view insertSubview:mapView atIndex:0];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	NSLog(@"did find a placemark, should be adding one");
	placemark = placemark;
	[mapView addAnnotation:placemark];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
	NSLog(@"view for annotation method, shoudl be adding a annotation");
	MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annotationView.animatesDrop = TRUE;
	return annotationView;
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
