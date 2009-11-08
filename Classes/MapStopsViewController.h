//
//  MapStopsViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ProgressViewController.h"

@interface MapStopsViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *mapView;
	ProgressViewController *progressViewController;
	NSMutableData *responseData;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain)	ProgressViewController *progressViewController;
@property (nonatomic, retain) NSMutableData *responseData;

-(IBAction)toggleMapStopsView:(id)sender;


@end