//
//  RoutesTableViewController.m
//

#import "TrainBrainAppDelegate.h"
#import "RoutesTableViewController.h"
#import "RouteCell.h"
#import "BasicCell.h"
#import "Route.h"
#import "Stop.h"
#import "StopsTableViewController.h"
#import "StopTimesTableViewController.h"
#import "NSString+BeetleFight.h"

@implementation RoutesTableViewController

@synthesize tableView, dataArraysForRoutesScreen, routes, stops, lastViewed, locationManager, myLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  self.myLocation = newLocation;
  
  UIApplication* app = [UIApplication sharedApplication];
  UIApplicationState state = [app applicationState];
  if (state == UIApplicationStateActive) {
    [self loadRoutesForLocation:self.myLocation];
    [self.locationManager stopUpdatingLocation];
  }
  
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [self setMyLocation:[[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223]];
  [self loadRoutesForLocation:self.myLocation];
  [self.locationManager stopUpdatingLocation];
  
  NSString *locationErrorMessage = @"Failed to acquire location. Location Services may be disabled.\n\n Pull to refresh data with pre-set location. Distances will not be accurate.";
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: locationErrorMessage
                                                    message:nil 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)loadRoutesForLocation:(CLLocation *)location {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
  if (last_stop_id != NULL) {
    [params setValue:last_stop_id forKey:@"last_viewed_stop_id"];
  }
  
  [Route routesWithNearbyStops:@"train/v1/routes/nearby_stops" near:location parameters:params block:^(NSDictionary *data) {
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    if (data == NULL || ![data isKindOfClass:[NSDictionary class]]) {
      UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
      container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5,self.view.frame.size.width, 50)];
      label.backgroundColor = [UIColor clearColor];
      label.textAlignment = UITextAlignmentLeft;
      label.textColor = [UIColor whiteColor];
      label.text = @"Error loading data. Please email support.";
      label.font = [UIFont boldSystemFontOfSize:14.0];
      [container addSubview:label];
      self.view = container;
      
    } else {
      
      self.routes = [data objectForKey:@"routes"];
      self.stops = [data objectForKey:@"stops"];
      self.lastViewed = [data objectForKey:@"last_viewed"];
      [self.tableView reloadData];
      [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    }
  }];
}

- (void) viewWillAppear:(BOOL)animated {
  TrainBrainAppDelegate *app = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"RoutesTableView"];
}

- (void)viewDidLoad {  
  
  UIWindow *window = [UIApplication sharedApplication].keyWindow;

  if ([CLLocationManager locationServicesEnabled]) {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [self.locationManager startUpdatingLocation];
    
  } else {

    [self setMyLocation:[[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223]];
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: @"Location Services Unavailable"
                          message: @"\n\nLocation Services are not available. A pre-set location will be used. Distances will not be accurate."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];

    UIApplication* app = [UIApplication sharedApplication];
    UIApplicationState state = [app applicationState];
    if (state == UIApplicationStateActive) {
      [self loadRoutesForLocation:self.myLocation];
    } 
  }
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];
  
  [super viewDidLoad];  
 
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  self.view = self.tableView;
  
	dataArraysForRoutesScreen = [[NSMutableArray alloc] init];
  
  Route *r1 = [[Route alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"route_desc", nil]];
	self.routes = [NSArray arrayWithObjects:r1, nil];
	NSDictionary *routesDict = [NSDictionary dictionaryWithObject:self.routes forKey:@"items"];
  
  NSArray *lastStopID = [NSArray arrayWithObjects:@"", nil];
  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:lastStopID forKey:@"items"];
	
	[dataArraysForRoutesScreen addObject:routesDict];
  [dataArraysForRoutesScreen addObject:lastStopIDDict];
	
	self.navigationItem.title = @"Routes";
  
  if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
  
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
  if ([self tableView:tv titleForHeaderInSection:section] != nil) {
    return 28;
  } else {
    return 0;
  }
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,30)] autorelease];
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,headerView.frame.size.width, headerView.frame.size.height)];
  headerLabel.textAlignment = UITextAlignmentLeft;
  headerLabel.textColor = [UIColor colorWithHexString:@"#4a3c00"];
  headerLabel.text = [self tableView:tv titleForHeaderInSection:section];
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.shadowColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
  headerLabel.shadowOffset = CGSizeMake(0,1);
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar_default.png"]];
  
  return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if (section == 0) {
    return [self.routes count];
  } else if (section == 1) {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
    if (last_stop_id != NULL) {
      return 1;
    } else {
      return 0;
    }
    
  } else if (section == 2) {
    return [self.stops count];
  } else {
    // should not reach here
    return 0;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == 0) {
    return @"Choose Your Line";
  } else if (section == 1) {
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
    if (last_stop_id != NULL) {
      return @"Last Viewed";
    } else {
      return NULL;
    }
    
  } else if (section == 2) {
    return @"Nearby Stops";
  }
  return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *BasicCellIdentifier = @"BasicCell";
  static NSString *CellIdentifier = @"Cell";

  if (indexPath.section == 0) {
    RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_lg.png"]];
    
    UIView *selectHighlightView = [[UIView alloc] init];
    [selectHighlightView setBackgroundColor:[UIColor blackColor]];
    [cell setSelectedBackgroundView: selectHighlightView];
    
    if ([self.routes objectAtIndex:indexPath.row]) {
      Route *route = (Route *)[self.routes objectAtIndex:indexPath.row];
      cell.title.text = route.long_name;
      cell.description.text = route.route_desc;
      cell.icon.image = [UIImage imageNamed:route.icon_path];
    }
    
    return cell;
    
  } else if (indexPath.section == 1) {
    
    RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
    
    UIView *selectHighlightView = [[UIView alloc] init];
    [selectHighlightView setBackgroundColor:[UIColor blackColor]];
    [cell setSelectedBackgroundView: selectHighlightView];

    if (self.lastViewed && [self.lastViewed valueForKey:@"stop"]) {
      Stop *stop = (Stop *)[self.lastViewed valueForKey:@"stop"];
      cell.title.text = stop.stop_name;
      cell.description.text = stop.headsign.headsign_name;
      cell.icon.image = [UIImage imageNamed:stop.icon_path];
      
      if ([self.lastViewed valueForKey:@"next_departure"] && 
          [[self.lastViewed valueForKey:@"next_departure"] isKindOfClass:[NSString class]] &&
          [[self.lastViewed valueForKey:@"next_departure"] length] > 0) {
        cell.extraInfo.text = [[self.lastViewed valueForKey:@"next_departure"] hourMinuteFormatted];
      }
    }
    
    return cell;
    
  } else if (indexPath.section == 2) {

    if ([self.stops count] == 0) {
      // TODO could put a basic table view cell with a message about no stops within 25 miles.
      
    } else if ([self.stops count] > 1) {
        
      RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      }
      cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
      
      UIView *selectHighlightView = [[UIView alloc] init];
      [selectHighlightView setBackgroundColor:[UIColor blackColor]];
      [cell setSelectedBackgroundView: selectHighlightView];
      
      if ([self.stops objectAtIndex:indexPath.row]) {
        Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
        cell.title.text = stop.stop_name;
        cell.description.text = stop.headsign.headsign_name;
        cell.icon.image = [UIImage imageNamed:stop.icon_path];
        
        if (self.myLocation) {
          double dist = [self.myLocation distanceFromLocation:stop.location] / 1609.344;
          if (dist < 100) {
            cell.extraInfo.text = [NSString stringWithFormat:@"%.1f miles", dist];
          }
        }
      }
      
      return cell;
    }
  }
  return NULL;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section == 0) {
    Route *route = (Route *)[self.routes objectAtIndex:indexPath.row];
    StopsTableViewController *target = [[StopsTableViewController alloc] init];
    target.selectedRoute = route;
    target.myLocation = self.myLocation;
    [[self navigationController] pushViewController:target animated:YES];
    
  } else if (indexPath.section == 1) {
    
    Stop *stop = (Stop *)[self.lastViewed valueForKey:@"stop"];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];
    [[self navigationController] pushViewController:target animated:YES];
    
  } else if (indexPath.section == 2) {
    
    if ([self.stops count] > 0) {
      Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
      StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
      [target setSelectedStop:stop];    
      [[self navigationController] pushViewController:target animated:YES];
    }
    
  }
	
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	[self tableView:tv didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 57;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)doneLoadingTableViewData {
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self loadRoutesForLocation:self.myLocation];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
  return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date];
}

- (void)dealloc {
	[dataArraysForRoutesScreen release];
  [super dealloc];  
  [tableView dealloc];
  [routes dealloc];
  [stops dealloc];
  [lastViewed dealloc];
  [myLocation dealloc];
  [locationManager dealloc];
}

@end