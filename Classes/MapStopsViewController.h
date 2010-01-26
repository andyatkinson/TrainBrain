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

@interface MapStopsViewController : UIViewController <MKMapViewDelegate, MBProgressHUDDelegate> {
	MKMapView *_mapView;
	NSMutableData *responseData;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD	*HUD;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

-(IBAction)refreshMap:(id)sender;

@end
