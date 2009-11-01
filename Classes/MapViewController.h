//
//  MapViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 9/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "StationAnnotation.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, MKReverseGeocoderDelegate> {
		MKMapView *mapView;
		MKPlacemark *placeMark;
		MKReverseGeocoder *geoCoder;
	NSString *stationLatitude;
	NSString *stationLongitude;
}

@property (nonatomic, retain) NSString *stationLatitude;
@property (nonatomic, retain) NSString *stationLongitude;

@end
