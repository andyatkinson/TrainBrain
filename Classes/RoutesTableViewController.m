//
//  RoutesTableViewController.m
//
//

#import "RoutesTableViewController.h"
#import "RouteCell.h"
#import "Route.h"
#import "Stop.h"
#import "TrainStationsViewController.h"

@implementation RoutesTableViewController

@synthesize tableView, dataArraysForRoutesScreen, routes, stops, locationManager, myLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self loadSpotsForLocation:newLocation];
  self.myLocation = newLocation;
  [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to acquire location." 
																									message:nil 
																								 delegate:nil 
																				cancelButtonTitle:@"OK" 
																				otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)loadSpotsForLocation:(CLLocation *)location {  
  NSDictionary *params = [NSDictionary dictionaryWithObject:@"1000" forKey:@"last_viewed_stop_id"];
  
  [Route routesWithNearbyStops:@"train/v1/routes/nearby_stops" near:location parameters:params block:^(NSDictionary *data) {
    
    //[HUD hide:YES];

    
    self.routes = [data objectForKey:@"routes"];
    self.stops = [data objectForKey:@"stops"];
    
    [self.tableView reloadData];
    
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    
    //self.navigationItem.rightBarButtonItem.enabled = YES;
    
  }];

}

- (void)viewDidLoad {
  
  // Load from a fixed location, in case location services are disabled or unavailable
  CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
  self.myLocation = mpls;
  [self loadSpotsForLocation:mpls];
  
  [self.locationManager startUpdatingLocation];
  
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];
  
  [super viewDidLoad];  
 
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];

	
	//Initialize the array.
	dataArraysForRoutesScreen = [[NSMutableArray alloc] init];
  
  Route *r1 = [[Route alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"route_desc", nil]];
	self.routes = [NSArray arrayWithObjects:r1, nil];
	NSDictionary *routesDict = [NSDictionary dictionaryWithObject:self.routes forKey:@"items"];
  
  NSArray *lastStopID = [NSArray arrayWithObjects:@"51234", nil];
  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:lastStopID forKey:@"items"];
	
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
  self.stops = [NSArray arrayWithObjects:s1, nil];
	NSDictionary *stopsDict = [NSDictionary dictionaryWithObject:self.stops forKey:@"items"];
	
	[dataArraysForRoutesScreen addObject:routesDict];
  [dataArraysForRoutesScreen addObject:lastStopIDDict];
	[dataArraysForRoutesScreen addObject:stopsDict];

	
	//Set the title
	self.navigationItem.title = @"Routes";
  
  self.view = self.tableView;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
	return [dataArraysForRoutesScreen count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
    return 28; // want to eliminate a 1px bottom gray line, and a 1px bottom white line under
  }
  else {
    // If no section header title, no section header needed
    return 0;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,29)] autorelease];
  
//  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
//  headerLabel.textAlignment = UITextAlignmentRight;
//  headerLabel.text = @"foo";
//  headerLabel.backgroundColor = [UIColor clearColor];
//  [headerView addSubview:headerLabel];
  
  NSString *filename = [[NSString alloc] init];
  if (section == 0) {
    filename = @"header_bar_choose_line";
  } else if (section == 1) {
    filename = @"header_bar_last_viewed";
  } else if (section == 2) {
    filename = @"header_bar_nearby_stops";
  }
  
  UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:filename ofType:@"png"]];
  UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
  
  
  [headerView addSubview:imgView];
  
  //[headerLabel release];
  
  return headerView;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//Number of rows it should expect should be based on the section
//	NSDictionary *dictionary = [dataArraysForRoutesScreen objectAtIndex:section];
//  NSArray *array = [dictionary objectForKey:@"items"];
//	return [array count];
  if (section == 0) {
    return [self.routes count];
  } else if (section == 1) {
    return 1;
  } else if (section == 2) {
    return [self.stops count];
  }
  
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == 0) {
    return @"Choose your line";
  } else if (section == 1) {
    return @"Last Viewed";
  } else if (section == 2) {
    return @"Nearby Stops";
  }
		
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  // indexPath.section == 0  to choose a specific section
  // e.g. if (indexPath.section == 0) { BigDepartureTableViewCell }

  if (indexPath.section == 0) {
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Route *route = (Route *)[self.routes objectAtIndex:indexPath.row];
    
    cell.title.text = route.long_name;
    cell.description.text = route.route_desc;
    
    cell.icon.image = [UIImage imageNamed:route.icon_path];
    
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_lg.png"]];
    
    return cell;
    
  } else if (indexPath.section == 1) {
    
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //NSDictionary *itemAtIndex = [NSDictionary dictionaryWithObject:@"foo bar" forKey:@"title"];
    NSDictionary *dictionary = [dataArraysForRoutesScreen objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"items"];
    NSString *route_title = [array objectAtIndex:indexPath.row];
    
    cell.title.text = route_title;
    //cell.description.text = @"foo";
    //cell.extraInfo.text = @"12 min";
    
    cell.icon.image = [UIImage imageNamed:@"icon_northstar.png"];
    
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
    
    return cell;

    
  } else if (indexPath.section == 2) {
    
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
    
    cell.title.text = stop.stop_name;
    cell.description.text = stop.stop_desc;
    //cell.extraInfo.text = @"4 blocks";
    
    
    
    double dist = [self.myLocation getDistanceFrom:stop.location] / 1609.344;
    cell.extraInfo.text = [NSString stringWithFormat:@"%.1f miles", dist];
    
    cell.icon.image = [UIImage imageNamed:stop.icon_path];
    
    cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
    
    return cell;
  }
  
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    // route_id available => go to stops
    Route *route = (Route *)[self.routes objectAtIndex:indexPath.row];
    
    TrainStationsViewController *target = [[TrainStationsViewController alloc] init];
    target.selectedRoute = route;
    target.my_location = self.myLocation;
    [[self navigationController] pushViewController:target animated:YES];
    
  } else if (indexPath.section == 1 || indexPath.section == 2) {
    
    // stop_id available => go to stop times


    
  }
	
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  // indexPath.section && indexPath.row (inside a section) are options to control in more detail
  return 57;
}

- (void)dealloc {
	
	[dataArraysForRoutesScreen release];
  [super dealloc];
}




@end



// SET HEADER SECTION heights
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//  if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
//    if (section == 1) {
//      return 100;
//    } else {
//      return 40;
//    }
//    
//  }
//  else {
//    // If no section header title, no section header needed
//    return 0;
//  }
//}