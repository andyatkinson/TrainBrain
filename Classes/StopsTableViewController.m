//
//  StopsTableViewController.m
//  TrainBrain
//
//  Created by Aaron Batalion on 3/26/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopsTableViewController.h"
#import "Stop.h"
#import "RouteCell.h"

@implementation StopsTableViewController

@synthesize tableView, stops, locationManager, myLocation, data;

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
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 260)];

  [super viewDidLoad];  
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  self.data = [[NSMutableArray alloc] init];
  
  Stop *s1 = [[Stop alloc] initWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"Loading...", @"stop_desc", nil]];
	self.stops = [NSArray arrayWithObjects:s1, nil];
	NSDictionary *stopsDict = [NSDictionary dictionaryWithObject:self.stops forKey:@"items"];
  
  [data addObject:stopsDict];
	
	//Set the title
	self.navigationItem.title = @"Stops";
  
  UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)] autorelease];
  
  UIView *headsignSwitcher = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - 20)];
  
  [container addSubview:headsignSwitcher];
  [container addSubview:self.tableView];
  
  self.view = container;
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  RouteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[RouteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  Stop *stop = (Stop *)[self.stops objectAtIndex:indexPath.row];
  
  //cell.title.text = stop.stop_name;
  cell.description.text = stop.stop_desc;
  //cell.extraInfo.text = @"4 blocks";
  
  
  
//  double dist = [self.myLocation getDistanceFrom:stop.location] / 1609.344;
//  cell.extraInfo.text = [NSString stringWithFormat:@"%.1f miles", dist];
//  
//  cell.icon.image = [UIImage imageNamed:stop.icon_path];
//  
//  cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
  
  return cell;
  
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 0;
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
