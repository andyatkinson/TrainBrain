//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RoutesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate> {
	UITableView *tableView;
	NSMutableArray *dataArraysForRoutesScreen;
  
  CLLocation *myLocation;
  CLLocationManager *locationManager;
  
  NSArray *routes;
  NSArray *stops;
  NSDictionary *lastViewed;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArraysForRoutesScreen;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSDictionary *lastViewed;

@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)loadSpotsForLocation:(CLLocation *)location;

@end
