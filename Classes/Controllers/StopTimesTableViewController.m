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
#import "BasicCell.h"

@implementation StopTimesTableViewController

@synthesize tableView, bigCell, data, stop_times, selectedStop;
@synthesize refreshTimer = _refreshTimer;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

-(void)hudWasHidden{
}

- (void) setupRefresh{

  if ( [self refreshTimer] != (id)[NSNull null] ) {
    StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:0];
    NSArray  *departureData = [stop_time getTimeTillDeparture];
    NSNumber *seconds = (NSNumber*) [departureData objectAtIndex:3];
    
    int interval = 0;
    if( [seconds intValue] < 30 ){
      interval = 30 + [seconds intValue];
    } else if ([seconds intValue] > 30 ) {
      interval = [seconds intValue] - 30;
    }
    
    [self setRefreshTimer: [NSTimer scheduledTimerWithTimeInterval:interval
                                                            target:self
                                                          selector:@selector(refeshTable)
                                                          userInfo:nil
                                                           repeats:NO]];
  }
}

- (void) refeshTable{
  StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:0];
  NSArray  *departureData = [stop_time getTimeTillDeparture];
  NSNumber *timeTillDeparture = (NSNumber*) [departureData objectAtIndex:0];
  if ([timeTillDeparture intValue] == 0) {
    
    UIApplication* app = [UIApplication sharedApplication];
    UIApplicationState state = [app applicationState];
    
    if(state == UIApplicationStateActive) {
      [self loadStopTimes];
    }
    
  } else {
    [self.tableView reloadData];
  }
  
  [self setRefreshTimer: [NSTimer scheduledTimerWithTimeInterval:60
                                                          target:self
                                                        selector:@selector(refeshTable)
                                                        userInfo:nil
                                                         repeats:NO]];

}

- (void)loadStopTimes {
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
  
  
  if (self.selectedStop == NULL || self.selectedStop.route.route_id == NULL) {
    NSLog(@"tried to call controller but didn't supply enough data. <selectedStop>: %@", self.selectedStop);

  } else {
    
    
    NSString *url = [NSString stringWithFormat:@"train/v1/routes/%@/stops/%@/stop_times", 
                     self.selectedStop.route.route_id, self.selectedStop.stop_id];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", [components hour]] forKey:@"hour"];
    
    /* Progress HUD overlay START */  
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    HUD = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    /* Progress HUD overlay END */
    
    [StopTime stopTimesSimple:url near:nil parameters:params block:^(NSArray *stops) {
      self.stop_times = stops;

      if ([self.stop_times count] > 0) {
        StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:0];
        [[self bigCell] setStopTime:stop_time];
        
        [self setupRefresh];
        
      } else {
        
        UIView *container = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,400)] autorelease];
        container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20,5,self.view.frame.size.width, 50)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.text = @"No upcoming departures.";
        label.font = [UIFont boldSystemFontOfSize:14.0];
        [container addSubview:label];
        self.view = container;
        
      }
        
      [self.tableView reloadData];
      
      NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
      [settings setObject:self.selectedStop.stop_id forKey:@"last_stop_id"];
      [settings synchronize];
      
      [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
      [HUD hide:YES];
      
      [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    }];    
  }  
}

- (void)viewDidLoad {
  
  // TODO set the custom background
  UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
  self.navigationItem.backBarButtonItem = backBarButton;
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  [backBarButton release];

  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 207, 270, 233)];
  
  [super viewDidLoad];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.data = [[NSMutableArray alloc] init];
  
  self.stop_times = [[NSArray alloc] init];
  [self loadStopTimes];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
  
  
  self.navigationItem.title = self.selectedStop.stop_name;
  
  if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
  
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
  headerLabel.textColor = [UIColor colorWithHexString:@"#4a3c00"];
  headerLabel.text = @"Upcoming Departures";
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.shadowColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
  headerLabel.shadowOffset = CGSizeMake(0,1);
  
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  
  headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"header_bar_default.png"]];
  
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
        return 28;
    } else if (indexPath.row == 1) {
        return 154;
    }
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
    return 2;
  } else if (section == 1) {
    return [self.stop_times count];
  } else {
    // error
    return 0;
  }

}
  

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  static NSString *BasicCellIdentifier = @"BasicCell";
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  
  if ([self.stop_times count] > 0) {
    if (indexPath.section == 0) {
      
      if (indexPath.row == 0) {
        
        BasicCell *cell = [thisTableView dequeueReusableCellWithIdentifier:BasicCellIdentifier];
        if (cell == nil) {
          cell = [[[BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BasicCellIdentifier] autorelease];
        }
        
        cell.titleLabel.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = [UIColor grayColor];
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cell.titleLabel.text = [NSString stringWithFormat:@"To %@", self.selectedStop.headsign.headsign_name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
      } else if (indexPath.row == 1)  {
        StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:0];
        
        if (bigCell == NULL) {
          [self setBigCell:[[BigDepartureTableViewCell alloc] init]];
          
          [[self bigCell] setStopTime:stop_time];
          [self bigCell].funnySaying.text = [FunnyPhrase rand];
          [self bigCell].description.text = @"Next estimated train departure:";
          
          [[self bigCell] startTimer];
          self.bigCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return [self bigCell];
      }
      
      
    } else if (indexPath.section == 1) {
      
      StopTime *stop_time = (StopTime *)[self.stop_times objectAtIndex:indexPath.row];
      StopTimeCell *cell = [thisTableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[[StopTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      }
      
      cell.icon.image = [UIImage imageNamed:@"icon_clock.png"];      
      [cell setStopTime:stop_time];
      cell.selectionStyle = UITableViewCellSelectionStyleNone;

      return cell;
      
    }
  }  

  return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
  //[self loadRoutesForLocation:self.myLocation];
  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	//_reloading = NO;
	//[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self loadStopTimes];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	//return _reloading; // should return if data source model is reloading
  return NO;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)dealloc {
  [super dealloc];
  [HUD dealloc];
}

@end