//
//  StopsOnMapViewController.m
//  TrainBrain
//

#import "StopsOnMapViewController.h"
#import "Stop.h"
#import "StopAnnotation.h"
#import "StopTimesTableViewController.h"

@implementation StopsOnMapViewController

@synthesize stops, mapView, selectedRoute, viewTitle;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)loadStops {
  NSString *url = [NSString stringWithFormat:@"train/v1/routes/%@/stops/all", self.selectedRoute.route_id];
  
  [Stop stopsWithURLString:url near:nil parameters:nil block:^(NSArray *data) {
    self.stops = data;
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
  
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 260)];  
  self.mapView.delegate = self;

	
	[self loadStops];
  
  self.title = self.viewTitle;
  
  self.view = self.mapView;
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

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {

  static NSString *ai = @"AnnotationIdentifier";
  MKPinAnnotationView *pv = (MKPinAnnotationView *)[mv dequeueReusableAnnotationViewWithIdentifier:ai];

  if (!pv) {
    pv = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ai] autorelease];
    
    NSRange hiawatha = [self.selectedRoute.route_id rangeOfString:@"55"];
    NSRange northstar = [self.selectedRoute.route_id rangeOfString:@"888"];
    if (hiawatha.location != NSNotFound) {
      pv.image = [UIImage imageNamed:@"hiaw_map_pin.png"];
    } else if(northstar.location != NSNotFound) {
      pv.image = [UIImage imageNamed:@"nstr_map_pin.png"];
    }
    
    [pv setUserInteractionEnabled:YES];
    [pv setEnabled:YES];
    [pv setCanShowCallout:YES];
    [pv setAnimatesDrop:NO];
    [pv setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    
  } else {
    
    //we're re-using an annotation view
    //update annotation property in case re-used view was for another  
    pv.annotation = annotation;
  }

	return pv;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	StopAnnotation *sa = (StopAnnotation *)[view annotation];

  StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
  [target setSelectedStop:sa.stop];  
  [[self navigationController] pushViewController:target animated:YES];
}


- (void)displayMapData {
  for (id stop in self.stops) {
    StopAnnotation *annotation = [StopAnnotation annotationWithStop:stop];
    [self.mapView addAnnotation:annotation];
    [stop release];
    
    // not releasing memory here because there is a crash
    //[annotation release];
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

-(void)hudWasHidden{
  
}


- (void)dealloc {
	[super dealloc];
	[mapView dealloc];
	[HUD dealloc];
  [stops dealloc];
  [selectedRoute dealloc];
  [viewTitle dealloc];
}


@end
