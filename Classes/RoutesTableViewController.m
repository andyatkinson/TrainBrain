//
//  RoutesTableViewController.m
//
//

#import "RoutesTableViewController.h"
#import "BigDepartureTableViewCell.h"

@implementation RoutesTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
	
	//Initialize the array.
	listOfItems = [[NSMutableArray alloc] init];
	
	NSArray *routes = [NSArray arrayWithObjects:@"Light rail", nil];
	NSDictionary *routesDict = [NSDictionary dictionaryWithObject:routes forKey:@"items"];
  
  NSArray *lastStopID = [NSArray arrayWithObjects:@"51234", nil];
  NSDictionary *lastStopIDDict = [NSDictionary dictionaryWithObject:lastStopID forKey:@"items"];
	
	NSArray *stops = [NSArray arrayWithObjects:@"Lake St", @"Franklink", @"MOA", nil];
	NSDictionary *stopsDict = [NSDictionary dictionaryWithObject:stops forKey:@"items"];
	
	[listOfItems addObject:routesDict];
  [listOfItems addObject:lastStopIDDict];
	[listOfItems addObject:stopsDict];
	
	//Set the title
	self.navigationItem.title = @"Departures";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return 154;
    }
  }
  return 44;
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
  
	return [listOfItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
    if (section == 1) {
      return 100;
    } else {
      return 40;
    }
    
  }
  else {
    // If no section header title, no section header needed
    return 0;
  }
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
  NSArray *array = [dictionary objectForKey:@"items"];
	return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == 0) {
    return NULL;
  } else if (section == 1) {
    return @"Last viewed stop";
  } else if (section == 2) {
    return @"Nearby stops";
  }
		
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";

  if (indexPath.section == 0) {
    
    BigDepartureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[BigDepartureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *itemAtIndex = [NSDictionary dictionaryWithObject:@"foo bar" forKey:@"title"];
    [cell setData:itemAtIndex];
      
    return cell;
    
  } else {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    //First get the dictionary object
    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"items"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.text = cellValue;
    return cell;
  }
  
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	

}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)dealloc {
	
	[listOfItems release];
  [super dealloc];
}


@end

