//
//  RootViewController.m
//  train brain
//
//  Created by Andy Atkinson on 8/22/09.
//  Copyright Andy Atkinson http://webandy.com 2009. All rights reserved.
//

#import "RootViewController.h"
#import "JSON/JSON.h" 
#import "TrainBrainAppDelegate.h"
#import "TrainStationsViewController.h"
#import "MapStopsViewController.h"
#import "Route.h"

@interface RootViewController (Private)
- (void)loadRailStations;
@end

@implementation RootViewController

@synthesize locationManager, startingPoint, tableView, appDelegate, routes;

- (void) initialize {
	}

//
// Hack to add 1px header/footer around tableview to prevent separator rows from showing
// See: http://stackoverflow.com/questions/1369831/eliminate-extra-separators-below-uitableview-in-iphone-sdk
// 
- (void) addHeaderAndFooter
{
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	v.backgroundColor = [UIColor clearColor];
	[self.tableView setTableHeaderView:v];
	[self.tableView setTableFooterView:v];
	[v release];
}

-(IBAction)refreshStations:(id)sender {
	[self loadRoutes];
}

- (void)viewDidLoad {
	
	// 231/231/231
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	tableView.separatorColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
	
	[super viewDidLoad];
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// prevent table view separator from showing on empty cells
	[self addHeaderAndFooter];
	
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
    
    HUD.labelText = @"Loading";
	[HUD show:YES];
	
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshStations:)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
    self.navigationItem.rightBarButtonItem.enabled = NO;
  
  NSLog(@"trying to read last stop ID");
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user_data.plist"];
  NSMutableDictionary *userData = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
  
  NSLog(@"read last stop ID: %@", [userData objectForKey:@"last_stop_id"]);
  
  [userData release];
  
    
    [self loadRoutes];
}

- (void)loadRoutes {
    [Route routesWithURLString:@"train/v1/routes" near:nil parameters:nil block:^(NSArray *records) {
        
      [HUD hide:YES];
      self.routes = records;
      [self.tableView reloadData];
      self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil) {
        self.startingPoint = newLocation;
	}
    
    [self.locationManager stopUpdatingLocation];
	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[HUD hide:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to acquire location." 
																									message:nil 
																								 delegate:nil 
																				cancelButtonTitle:@"OK" 
																				otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	
	// Unselect the selected row if any
	NSIndexPath *selection = [tableView indexPathForSelectedRow];
	if (selection) {
        [tableView deselectRowAtIndexPath:selection animated:YES];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.routes count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellId = @"TrainLineCell";
	
	TrainLineCell *cell = (TrainLineCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TrainLineCell" owner:nil options:nil];
	
	for(id currentObject in nibObjects) {
		if([currentObject isKindOfClass:[TrainLineCell class]]) {
			cell = (TrainLineCell *)currentObject;
		}
	}
	
	if([self.routes count] > 0) {
    Route *route = (Route *)[self.routes objectAtIndex:indexPath.row];

		[[cell lineTitle] setText:route.long_name];
		[[cell lineDescription] setText:route.short_name];
		[cell disclosureArrow].image = [UIImage imageNamed:@"icon_arrow.png"];
		
		if ([route.long_name rangeOfString:@"Hiawatha"].location == NSNotFound) {
			[cell lineImage].image = [UIImage imageNamed:@"icon_northstar.png"];
		} else {
			[cell lineImage].image = [UIImage imageNamed:@"icon_hiawatha.png"];
		}
		
		cell.backgroundView = [[[GradientView alloc] init] autorelease];
	}
	
	return cell;
}


// set the table view cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// do I need to set this if the height is specified in IB?
	return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Route *route = (Route *)[self.routes objectAtIndex:indexPath.row];
  TrainStationsViewController *target = [[TrainStationsViewController alloc] init];
  target.selectedRoute = route;
	target.my_location = self.startingPoint;
	[[self navigationController] pushViewController:target animated:YES];
	
}

- (void)dealloc {
	[locationManager release];
	[startingPoint release];
	[tableView release];
	[super dealloc];
}

@end