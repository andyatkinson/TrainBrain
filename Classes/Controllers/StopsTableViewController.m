//
//  StopsTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopsTableViewController.h"
#import "Stop.h"
#import "StopTimesTableViewController.h"
#import "RouteCell.h"
#import "StopsOnMapViewController.h"

@implementation StopsTableViewController

@synthesize tableView, headsigns, stops, locationManager, myLocation, data, selectedRoute, stopsIndex0, stopsIndex1;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadStopsWithHeadsigns:(CLLocation *)location {
    NSString *url = [NSString stringWithFormat:@"train/v1/routes/%@/stops/with_headsigns", self.selectedRoute.route_id];
  
    [Stop stopsWithHeadsigns:url near:location parameters:nil block:^(NSDictionary *blockdata) {
    self.headsigns = [blockdata objectForKey:@"headsigns"];
    
    self.stopsIndex0 = [blockdata objectForKey:@"stopsIndex0"];
    self.stopsIndex1 = [blockdata objectForKey:@"stopsIndex1"];
    
    self.stops = self.stopsIndex0;
    
    [self.tableView reloadData];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
  }];
  
}

- (void)loadMapView {
  StopsOnMapViewController *target = [[StopsOnMapViewController alloc] init];
  [target setSelectedRoute:self.selectedRoute];
  [[self navigationController] pushViewController:target animated:YES];
}

- (void)viewDidLoad
{
  
  CLLocation *mpls = [[CLLocation alloc] initWithLatitude:44.949651 longitude:-93.242223];
  self.myLocation = mpls;
  [self loadStopsWithHeadsigns:mpls];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 260)];

  [super viewDidLoad];  
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  // set height of frame of tableview
  CGRect tvframe = [self.tableView frame];
  [self.tableView setFrame:CGRectMake(tvframe.origin.x, 
                                 tvframe.origin.y, 
                                 tvframe.size.width, 
                                 tvframe.size.height + 47)];
  
  
  self.data = [[NSMutableArray alloc] init];
  
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_name", nil]];
	self.stops = [NSArray arrayWithObjects:s1, nil];
	NSDictionary *stopsDict = [NSDictionary dictionaryWithObject:self.stops forKey:@"items"];
  [data addObject:stopsDict];
	
	//Set the title
	self.navigationItem.title = self.selectedRoute.short_name;
  
  UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
  container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  UIView *headsignSwitcher = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 50)];
  
  SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"Downtown Mpls", @"Mall of America", nil]];
  navSC.height = 50.0f;
  navSC.font = [UIFont boldSystemFontOfSize:15];
  
  navSC.tintColor = [UIColor blackColor]; // background color
  
  navSC.thumb.tintColor = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:4/255.0 alpha:1];
  
  navSC.changeHandler = ^(NSUInteger newIndex) {
    if ([self.stopsIndex0 count] > 0 && [self.stopsIndex1 count] > 0) {
      
      if (newIndex == 0) {
        self.stops = self.stopsIndex0;
      } else if (newIndex == 1) {
        self.stops = self.stopsIndex1;
      }
      
      [self.tableView reloadData];
      [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
  };
  
	[headsignSwitcher addSubview:navSC];
	[navSC release];
	
	navSC.center = CGPointMake(self.view.frame.size.width / 2, 30);
  
  [container addSubview:headsignSwitcher];
  [container addSubview:self.tableView];
  
  UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
                                                                style:UIBarButtonItemStylePlain 
                                                                target:self 
                                                               action:@selector(loadMapView)];
  self.navigationItem.rightBarButtonItem = mapButton;
  [mapButton release];

  
  UIImage *backButton = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
  self.view = container;
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 57;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [stops count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString *CellIdentifier = @"Cell";
  
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
}

- (void) segmentedControlChangedValue:(SVSegmentedControl *)segmentedControl{
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
    StopTimesTableViewController *target = [[StopTimesTableViewController alloc] init];
    [target setSelectedStop:stop];  
    [[self navigationController] pushViewController:target animated:YES];
}

@end
