//
//  StopTimesTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopTimesTableViewController.h"
#import "BigDepartureTableViewCell.h"
#import "RouteCell.h"

@implementation StopTimesTableViewController

@synthesize tableView, data, stop_times;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];
  
    [super viewDidLoad];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.data = [[NSMutableArray alloc] init];

  
  self.stop_times = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObject:self.stop_times forKey:@"items"];
	
	[data addObject:dict];

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
    return 3;
  } else {
    // error
    return 0;
  }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
  if (indexPath.section == 0) {

    BigDepartureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    cell = [[BigDepartureTableViewCell alloc] init];

    cell.bigDeparture.text = @"4m 34s";
    cell.funnySaying.text = @"Hurry Up. No Shoving.";
    cell.description.text = @"The next estimated train departs:";
    cell.formattedTime.text = @"11:15 PM";
    cell.price.text = @"$1.75";
    
    return cell;
    
  } else if (indexPath.section == 1) {
    
    static NSString *CellIdentifier = @"Cell";
    RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    
//    NSDictionary *dictionary = [data objectAtIndex:indexPath.section];
//    NSArray *array = [dictionary objectForKey:@"items"];
//    NSString *foo = [array objectAtIndex:indexPath.row];

    cell.title.text = @"foo";
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