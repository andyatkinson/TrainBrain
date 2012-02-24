//
//  TrainStationsViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 10/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TrainStationsViewController.h"
#import "JSON/JSON.h"
#import "TimeEntryViewController.h"
#import "Stop.h"
#import "StopGroup.h"

@implementation TrainStationsViewController

@synthesize tableView, appDelegate, selectedRoute, mapStopsViewController, my_location, stop_groups;


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

-(IBAction)loadMapView:(id)sender {
	
	mapStopsViewController = [[MapStopsViewController alloc] initWithNibName:@"MapStopsViewController" bundle: [NSBundle mainBundle]];
	mapStopsViewController.route_id = selectedRoute.route_id;
	[[self navigationController] pushViewController:mapStopsViewController animated:YES];
	
	// know the current route, so kick out a request to show the stops on map with the route
}

- (void)viewDidLoad {
	// 231/231/231
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	tableView.separatorColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
	
	// prevent table view separator from showing on empty cells
	[self addHeaderAndFooter];
	
	[super viewDidLoad];
	
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(loadMapView:)];
	self.navigationItem.rightBarButtonItem = mapButton;
	[mapButton release];	
  self.navigationItem.rightBarButtonItem.enabled = NO;
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = selectedRoute.long_name;
    
    HUD.labelText = @"Loading";
    
    [self loadStops];
}



- (void)viewWillAppear:(BOOL)animated
{
	
	// Unselect the selected row if any
	NSIndexPath*	selection = [tableView indexPathForSelectedRow];
	if (selection) {
		[tableView deselectRowAtIndexPath:selection animated:YES];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.stop_groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"StationCell";
	
	StationCell *cell = (StationCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"StationCell" owner:nil options:nil];
	
	for(id currentObject in nibObjects) {
		if([currentObject isKindOfClass:[StationCell class]]) {
			cell = (StationCell *)currentObject;
		}
	}
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    if([self.stop_groups count] > 0) {
        StopGroup *group = (StopGroup *)[self.stop_groups objectAtIndex:indexPath.row];
        Stop *stop = (Stop*)[group.stops objectAtIndex:0];
        cell.stationName.text = stop.stop_name;
        
        double dist = [self.my_location getDistanceFrom:stop.location] / 1609.344;
        
        cell.subtitle.text = [NSString stringWithFormat:@"%.1f miles", dist];
        cell.backgroundView = [[[GradientView alloc] init] autorelease];
    }
	
	return cell;
}

- (void)loadStops {
    NSString *requestURL = [NSString stringWithFormat:@"train/v1/routes/%@/stops", self.selectedRoute.route_id];
    
    [Stop stopGroupsWithURLString:requestURL near:self.my_location parameters:nil block:^(NSArray *records) {
      
      self.navigationItem.rightBarButtonItem.enabled = YES;
        
        [HUD hide:YES];
        self.stop_groups = records;
        [self.tableView reloadData];
        
    }];
}

// set the table view cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// what should it be really?
	return 56;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StopGroup *group = (StopGroup *)[self.stop_groups objectAtIndex:indexPath.row];
  
  Stop *stop = (Stop*)[group.stops objectAtIndex:0];

  
  //store the stop_id from the first stop in the group
  NSLog(@"writing user data");
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"user_data.plist"];
  
  NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];

  
  [data setObject:stop.stop_id forKey:@"last_stop_id"];
  
  [data writeToFile: path atomically:YES];
  [data release];


    TimeEntryViewController *controller = [[TimeEntryViewController alloc] init];
    [controller setSelectedRoute:self.selectedRoute];
    [controller setSelectedStopName:group.name];
    [controller setSelectedStops:group.stops];
	[[self navigationController] pushViewController:controller animated:YES];
}

- (void)hudWasHidden
{
}

- (void)dealloc {
    [super dealloc];
    [tableView dealloc];
    [appDelegate dealloc];
}


@end
