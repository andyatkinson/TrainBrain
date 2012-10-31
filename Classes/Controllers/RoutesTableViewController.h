//
//  RoutesTableViewController.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"

@interface RoutesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, EGORefreshTableHeaderDelegate> {
	UITableView *tableView;
  CLLocation *myLocation;
  CLLocationManager *locationManager;
  NSArray *routes;
  NSArray *stops;
  NSDictionary *lastViewed;
  EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *routes;
@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSDictionary *lastViewed;

@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)loadRoutesForLocation:(CLLocation *)location;

@end
