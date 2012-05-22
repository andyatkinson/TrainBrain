//
//  RoutesTableViewController.m
//
//

#import "RoutesTableViewController.h"
#import "RouteCell.h"
#import "Route.h"
#import "Stop.h"
#import "StopsTableViewController.h"
#import "StopTimesTableViewController.h"
#import "NSString+BeetleFight.h"

@implementation RoutesTableViewController

@synthesize tableView, dataArraysForRoutesScreen, routes, stops, lastViewed, locationManager, myLocation;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self loadRoutesForLocation:newLocation];
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

- (void)loadRoutesForLocation:(CLLocation *)location {
	//NSDictionary *params = [NSDictionary dictionaryWithObject:@"1000" forKey:@"last_viewed_stop_id"];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	NSString *last_stop_id = [settings stringForKey: @"last_stop_id"];
	if (last_stop_id != NULL) {
		[params setValue:last_stop_id forKey:@"last_viewed_stop_id"];
	}

	[Route routesWithNearbyStops:@"train/v1/routes/nearby_stops" near:location parameters:params block:^(NSDictionary *data) {
	         self.routes = [data objectForKey:@"routes"];
	         self.stops = [data objectForKey:@"stops"];
	         self.lastViewed = [data objectForKey:@"last_viewed"];

	         [self.tableView reloadData];
	         [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
	         [HUD hide:YES];
	 }];

}

- (void)viewDidLoad {

	/* Progress HUD overlay START */
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	[HUD show:YES];
	/* Progress HUD overlay END */

	// Load from a fixed location, in case location services are disabled or unavailable
	CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
	self.myLocation = mpls;
	[self loadRoutesForLocation:mpls];

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

	NSArray *lastStopID = [NSArray arrayWithObjects:@"", nil];
	NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:lastStopID forKey:@"items"];


	Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
	self.stops = [NSArray arrayWithObjects:s1, nil];
	NSDictionary *stopsDict = [NSDictionary dictionaryWithObject:self.stops forKey:@"items"];

	[dataArraysForRoutesScreen addObject:routesDict];
	[dataArraysForRoutesScreen addObject:lastStopIDDict];
	[dataArraysForRoutesScreen addObject:stopsDict];

	self.navigationItem.title = @"train brain";

	self.view = self.tableView;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return [dataArraysForRoutesScreen count];
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)section {
	if ([self tableView:tv titleForHeaderInSection:section] != nil) {
		return 28; // want to eliminate a 1px bottom gray line, and a 1px bottom white line under
	}
	else {
		// If no section header title, no section header needed
		return 0;
	}
}

- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)section {

	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,30)] autorelease];

	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,headerView.frame.size.width, headerView.frame.size.height)];
	headerLabel.textAlignment = UITextAlignmentLeft;
	headerLabel.textColor = [UIColor blackColor];
	headerLabel.text = [self tableView:tv titleForHeaderInSection:section];
	headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
	headerLabel.shadowColor = [UIColor whiteColor];
	headerLabel.shadowOffset = CGSizeMake(0,1);

	headerLabel.backgroundColor = [UIColor clearColor];
	[headerView addSubview:headerLabel];

	headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar_default.png"]];

	return headerView;
}


// Customize the number of rows in the table view.
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

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";

	if (indexPath.section == 0) {
		RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

		RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		Stop *stop = (Stop *)[self.lastViewed valueForKey:@"stop"];
		cell.title.text = stop.stop_name;
		cell.description.text = stop.stop_desc;
		if ([self.lastViewed valueForKey:@"next_depature"]) {
			cell.extraInfo.text = [[self.lastViewed valueForKey:@"next_departure"] hourMinuteFormatted];
		}
		cell.icon.image = [UIImage imageNamed:stop.icon_path];
		cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];

		return cell;


	} else if (indexPath.section == 2) {

		RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

		Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
		cell.title.text = stop.stop_name;
		cell.description.text = stop.stop_desc;

		double dist = [self.myLocation distanceFromLocation:stop.location] / 1609.344;

		cell.extraInfo.text = [NSString stringWithFormat:@"%.1f miles", dist];
		cell.icon.image = [UIImage imageNamed:stop.icon_path];
		cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];

		return cell;
	}

	return NULL;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		// route_id available => go to stops
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

		Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
		StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
		[target setSelectedStop:stop];

		[[self navigationController] pushViewController:target animated:YES];
	}

}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {

	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tv accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

	[self tableView:tv didSelectRowAtIndexPath:indexPath];
}

-(void)hudWasHidden {
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