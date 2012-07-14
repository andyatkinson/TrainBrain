//
//  StopsOnMapViewController.h
//  TrainBrain
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TrainBrainAppDelegate.h"
#import "MBProgressHUD.h"
#import "Route.h"

@interface StopsOnMapViewController : UIViewController <MKMapViewDelegate, MBProgressHUDDelegate> {
	MKMapView *mapView;
	MBProgressHUD	*HUD;
  NSArray *stops;
	Route *selectedRoute;
  NSString *viewTitle;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (readwrite, nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) Route *selectedRoute;
@property (nonatomic, retain) NSString *viewTitle;

- (void)displayMapData;
- (void)loadStops;

@end
