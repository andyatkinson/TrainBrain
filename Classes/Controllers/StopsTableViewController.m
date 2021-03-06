//
//  StopsTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "TrainBrainAppDelegate.h"
#import "StopsTableViewController.h"
#import "Stop.h"
#import "StopTimesTableViewController.h"
#import "RouteCell.h"
#import "StopsOnMapViewController.h"
#import "UIColor_Categories.h"

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
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
  HUD.labelText = @"Loading";
	[HUD show:YES];
    
    NSString *url = [NSString stringWithFormat:@"train/v1/routes/%@/stops/with_headsigns", self.selectedRoute.route_id];
  
    [Stop stopsWithHeadsigns:url near:location parameters:nil block:^(NSDictionary *blockdata) {
      if(! [blockdata isKindOfClass:[NSDictionary class]]){
        [HUD hide:YES];
        
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
        
        return;
      }
      self.headsigns = [blockdata objectForKey:@"headsigns"];
      self.stopsIndex0 = [blockdata objectForKey:@"stopsIndex0"];
      self.stopsIndex1 = [blockdata objectForKey:@"stopsIndex1"];
      self.stops = self.stopsIndex0;
      
      UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
      container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
      
      UIView *headsignSwitcher = [[UIView alloc] initWithFrame:CGRectMake(0,-2,self.view.frame.size.width, 55)];

      SVSegmentedControl *navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[self.headsigns valueForKey:@"headsign_name"]];
      
      navSC.height = 31.0f;
      navSC.font = [UIFont boldSystemFontOfSize:13];
      navSC.tintColor = [UIColor blackColor]; // background color
      navSC.cornerRadius = 6.0;
      navSC.crossFadeLabelsOnDrag = NO;
      navSC.thumbEdgeInset = UIEdgeInsetsMake(2, 1, 1, 1);
      navSC.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 22);
      navSC.thumb.tintColor = [UIColor colorWithHexString:@"#FFDE00"];
      navSC.thumb.shouldCastShadow = NO;
      navSC.thumb.textColor = [UIColor colorWithHexString:@"#333333"];
      navSC.thumb.textShadowColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
      navSC.thumb.textShadowOffset = CGSizeMake(0,1);
      
      navSC.changeHandler = ^(NSUInteger newIndex) {
        if ([self.stopsIndex0 count] > 0 && [self.stopsIndex1 count] > 0) {
          if (newIndex == 0) {
            self.stops = self.stopsIndex0;
          } else if (newIndex == 1) {
            self.stops = self.stopsIndex1;
          }
          
          [self.tableView reloadData];
          [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
        }
      };
      
      [headsignSwitcher addSubview:navSC];
      [navSC release];
      
      navSC.center = CGPointMake(self.view.frame.size.width / 2, 25);
      
      [container addSubview:headsignSwitcher];
      [container addSubview:self.tableView];
      
      self.view = container;
      
      [HUD hide:YES];
      [self.tableView reloadData];
      [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
  }];
  
}

- (void)loadMapView {
  StopsOnMapViewController *target = [[StopsOnMapViewController alloc] init];
  [target setSelectedRoute:self.selectedRoute];
  [target setViewTitle:self.title];
  [[self navigationController] pushViewController:target animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
  TrainBrainAppDelegate *app = (TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
  [app saveAnalytics:@"StopsTableView"];
}

- (void)viewDidLoad
{

  [self loadStopsWithHeadsigns:self.myLocation];
  
  CGRect screenRect     = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight  = screenRect.size.height;
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, screenHeight-200)];

  [super viewDidLoad];  
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  CGRect tvframe = [self.tableView frame];
  [self.tableView setFrame:CGRectMake(tvframe.origin.x, 
                                 tvframe.origin.y, 
                                 tvframe.size.width, 
                                 tvframe.size.height + 42)];
  
  
  self.data = [[NSMutableArray alloc] init];
  
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_name", nil]];
	self.stops = [NSArray arrayWithObjects:s1, nil];
	NSDictionary *stopsDict = [NSDictionary dictionaryWithObject:self.stops forKey:@"items"];
  [data addObject:stopsDict];

  NSRange hiawatha = [self.selectedRoute.route_id rangeOfString:@"55"];
  NSRange northstar = [self.selectedRoute.route_id rangeOfString:@"888"];
  if (hiawatha.location != NSNotFound) {
    self.title = @"Hiawatha Stations";
  } else if(northstar.location != NSNotFound) {
    self.title = @"Northstar Stations";
  }
  
  UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [mapBtn setFrame:CGRectMake(0.0f, 0.0f, 35.0f, 30.0f)];
  [mapBtn addTarget:self action:@selector(loadMapView) forControlEvents:UIControlEventTouchUpInside];
  [mapBtn setImage:[UIImage imageNamed:@"btn_map_norm.png"] forState:UIControlStateNormal];
  UIBarButtonItem *mapButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapBtn];
  self.navigationItem.rightBarButtonItem = mapButtonItem;
  [mapButtonItem release];
  
  
  UIImage *backButton = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
  UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
  container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  self.view = container;
}

-(void)hudWasHidden {
  [HUD removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  RouteCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
  cell.title.text = stop.stop_name;
  
  double dist = [self.myLocation distanceFromLocation:stop.location] / 1609.344;
  cell.extraInfo.text = [NSString stringWithFormat:@"%.1f mi", dist];
  
  cell.icon.image = [UIImage imageNamed:stop.icon_path];
  cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
  
  UIView *selectHighlightView = [[UIView alloc] init];
  [selectHighlightView setBackgroundColor:[UIColor blackColor]];
  [cell setSelectedBackgroundView: selectHighlightView];
  
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

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [HUD hide:YES];
}

- (void)dealloc {
	[HUD dealloc];
  [super dealloc];
  [tableView dealloc];
  [headsigns dealloc];
  [stops dealloc];
  [stopsIndex0 dealloc];
  [stopsIndex1 dealloc];
  [data dealloc];
  [myLocation dealloc];
  [locationManager dealloc];
  [selectedRoute dealloc];
}

@end
