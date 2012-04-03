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

@implementation StopTimesTableViewController

@synthesize tableView, data, stop_times, routeID, stopID;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)loadStopTimes {
  // TODO get current hour, route_id, stop_id that was picked
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
  int hour = (int)[components hour];
  
  NSString *routeID = @"55-55";
  NSString *stopID = @"17874";
  
  NSString *url = [NSString stringWithFormat:@"train/v1/routes/%@/stops/%@/stop_times", routeID, stopID];
  NSDictionary *params = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", [components hour]] forKey:@"hour"];
  
  [StopTime stopTimesSimple:url near:nil parameters:params block:^(NSDictionary *data) {
    self.stop_times = data;
    
    [self.tableView reloadData];
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];    
  }];
  
}

- (void)viewDidLoad
{
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];
  
    [super viewDidLoad];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.data = [[NSMutableArray alloc] init];
  
  [self loadStopTimes];
  
  StopTime *st1 = [[StopTime alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"$2.25", @"price", nil]];
  StopTime *st2 = [[StopTime alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"$2.25", @"price", nil]];
  
  self.stop_times = [NSArray arrayWithObjects:st1, st2, nil];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  
  self.navigationItem.title = @"Warehouse Station";
  
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
    return 4;
  } else {
    // error
    return 0;
  }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
  if (indexPath.section == 0) {
    
    StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:indexPath.row];

    BigDepartureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    cell = [[BigDepartureTableViewCell alloc] init];

    cell.bigDeparture.text = stop_time.departure_time;
    
    NSArray *phrasesArray = [NSArray arrayWithObjects:@"Hurry Up. No Shoving.", @"Cool story, bro.", nil];
    
    NSUInteger randomIndex = arc4random() % [phrasesArray count];
    
    cell.funnySaying.text = [phrasesArray objectAtIndex:randomIndex];
    
    
    cell.description.text = @"The next estimated train departs:";
    cell.formattedTime.text = stop_time.departure_time;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [formatter dateFromString:stop_time.departure_time];
    
    [formatter setDateFormat:@"HH:mm a"];
    
    NSString *formattedTime = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    [formatter release];
    
    cell.formattedTime.text = formattedTime;
    
    
    cell.price.text = stop_time.price;
    
    return cell;
    
  } else if (indexPath.section == 1) {

    StopTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    cell = [[[StopTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

    cell.icon.image = [UIImage imageNamed:@"icon_clock.png"];
    cell.relativeTime.text = @"09m";
    cell.scheduleTime.text = @"9h 19m";
    cell.price.text = @"$2.25";

    return cell;
    
  }
    

}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
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