//
//  MapStopsViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 11/4/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrainBrainAppDelegate.h"
#import "MBProgressHUD.h"
#import "CustomPinBlue.h"
#import "CustomPinBlack.h"

@interface MapStopsViewController : UIViewController <MKMapViewDelegate, MBProgressHUDDelegate> {
	MKMapView *mapView;
	MBProgressHUD	*HUD;
  NSArray *stops;
	NSString *route_id;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (readwrite, nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSString *route_id;

- (void) displayMapData;
- (void)loadStops;

@end
