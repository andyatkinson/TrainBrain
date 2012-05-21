//
//  StopTimesTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopTimesTableViewController.h"
#import "BigDepartureTableViewCell.h"
#import "RouteCell.h"
#import "StopTimeCell.h"
#import "StopTime.h"
#import "NSString+BeetleFight.h"
#import "FunnyPhrase.h"

@implementation StopTimesTableViewController

@synthesize tableView, data, stop_times, selectedStop;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)loadStopTimes {
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
  
  if (self.selectedStop == NULL || self.selectedStop.route.route_id == NULL) {
    NSLog(@"error, exiting, got stop: %@", self.selectedStop);

  } else {
    
    
    NSString *url = [NSString stringWithFormat:@"train/v1/routes/%@/stops/%@/stop_times", 
                     self.selectedStop.route.route_id, self.selectedStop.stop_id];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", [components hour]] forKey:@"hour"];
    
    [StopTime stopTimesSimple:url near:nil parameters:params block:^(NSArray *blockdata) {
      self.stop_times = blockdata;
      
      [self.tableView reloadData];
      
      NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
      [settings setObject:self.selectedStop.stop_id forKey:@"last_stop_id"];
      [settings synchronize];
      
      [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];

    }];
    
  }
  
  
}

- (void)viewDidLoad
{
  
  // TODO set the custom background
  UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backBarButton;
  [backBarButton release];

  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];
  
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.data = [[NSMutableArray alloc] init];
  
  [self loadStopTimes];

  
  self.stop_times = [[NSArray alloc] init];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  
  self.navigationItem.title = self.selectedStop.stop_name;
  
  self.view = self.tableView;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,30)] autorelease];
  
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,headerView.frame.size.width, headerView.frame.size.height)];
  headerLabel.textAlignment = UITextAlignmentLeft;
  headerLabel.textColor = [UIColor blackColor];
  headerLabel.text = @"Upcoming Departures";
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.shadowColor = [UIColor whiteColor];
  headerLabel.shadowOffset = CGSizeMake(0,1);
  
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  
  headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar_default.png"]];
  
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 154;
  } 
  return 57;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0;
  } else if (section == 1) {
    return 28;
  }
  else {
    // error case
    return 0;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return 1;
  } else if (section == 1) {
    return [self.stop_times count];
  } else {
    // error
    return 0;
  }

}
  

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  
  if ([self.stop_times count] > 0) {
    if (indexPath.section == 0) {
      
      StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:indexPath.row];
      
      BigDepartureTableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];    
      cell = [[BigDepartureTableViewCell alloc] init];
      
      cell.bigDepartureHour.text = [NSString stringWithFormat:@"%dh", stop_time.departure_time_hour];
      cell.bigDepartureMinute.text = [NSString stringWithFormat:@"%dm", stop_time.departure_time_minute];
      cell.funnySaying.text = [FunnyPhrase rand];
      cell.description.text = @"Next estimated train departure:";
      cell.formattedTime.text = stop_time.departure_time;
      
      cell.formattedTime.text = [stop_time.departure_time hourMinuteFormatted];
      cell.price.text = stop_time.price;
      return cell;
      
      
    } else if (indexPath.section == 1) {
      
      StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:indexPath.row];
      StopTimeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];    
      cell = [[[StopTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      
      cell.icon.image = [UIImage imageNamed:@"icon_clock.png"];
      cell.relativeTimeHour.text = [NSString stringWithFormat:@"%dh", stop_time.departure_time_hour];
      cell.relativeTimeMinute.text = [NSString stringWithFormat:@"%dm", stop_time.departure_time_minute];
      cell.scheduleTime.text = [stop_time.departure_time hourMinuteFormatted];
      cell.price.text = stop_time.price;
      
      return cell;
      
    }
  }  

  return cell;
}

@end