//
//  InfoTableViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "InfoTableViewController.h"
#import "InfoDetailViewController.h"

@implementation InfoTableViewController

@synthesize dataArrays, tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (UIView *)tableView:(UITableView *)tView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,29)] autorelease];
  
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
  headerLabel.textAlignment = UITextAlignmentLeft;
  headerLabel.text = [self tableView:tView titleForHeaderInSection:section];
  headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
  headerLabel.textColor = [UIColor grayColor];
  headerLabel.backgroundColor = [UIColor clearColor];
  [headerView addSubview:headerLabel];
  [headerLabel release];
  
  return headerView;
}

- (void)viewDidLoad {
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  
  [super viewDidLoad];  
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
  self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_app.png"]];
	
	//Initialize the array.
	dataArrays = [[NSMutableArray alloc] init];
  
  NSArray *general = [NSArray arrayWithObjects:@"Hiawatha Light Rail", @"Northstar Commuter Rail", nil];
  NSArray *metroTransit = [NSArray arrayWithObjects:@"Call Metro Transit", nil];
  NSArray *support = [NSArray arrayWithObjects:@"Email the team", nil];

	[self.dataArrays addObject:general];
  [self.dataArrays addObject:metroTransit];
  [self.dataArrays addObject:support];
	
	//Set the title
	self.navigationItem.title = @"Information";
  
  self.view = self.tableView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // these could be array counts instead of hard-coded
  if (section == 0) {
    return 2;
  } else if (section == 1) {
    return 1;
  } else if (section == 2) {
    return 1;
  } else {
    // should not reach here
    return 0;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
    return @"Rider Information";
  } else if (section == 1) {
    return @"Metro Transit";
  } else if (section == 2) {
    return @"Application Support";
  }
  return NULL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.dataArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      cell.backgroundColor = [UIColor clearColor];
      cell.textLabel.textColor = [UIColor whiteColor];
      cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    if (indexPath.section == 0) {
      cell.accessoryView = [[ UIImageView alloc ] initWithImage:[UIImage imageNamed:@"arrow_cell.png"]];
    }
  
    cell.textLabel.text = [[self.dataArrays objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (void)composeEmail:(NSString *)emailAddr {
  NSArray *recipients = [[NSArray alloc] initWithObjects:emailAddr, nil];
  
  NSString *emailBody = @"<br/><br/>Download <a href='http://itunes.apple.com/us/app/train-brain/id328945770'>Train Brain</a> for iOS and follow <a href='http://twitter.com/trainbrainapp'>@trainbrainapp</a> on twitter";
  
  if ([MFMailComposeViewController canSendMail]) {
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setToRecipients:recipients];
    [mailViewController setSubject:@"Message from train brain"];
    [mailViewController setMessageBody:emailBody isHTML:YES];
    [[mailViewController navigationBar] setTintColor:[UIColor blackColor]];
    
    [self presentModalViewController:mailViewController animated:YES];
    [mailViewController release];
    
  } else {
    NSLog(@"can't send email");
  }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
  [self dismissModalViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    InfoDetailViewController *target = [[InfoDetailViewController alloc] init];
    if (indexPath.row == 0) {
      target.selectedRow = @"hiawatha";
    } else if (indexPath.row == 1) {
      target.selectedRow = @"northstar";
    }
    [[self navigationController] pushViewController:target animated:YES];
  } else if (indexPath.section == 1) {
    
    if (indexPath.row == 0) {
      // call metro transit
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://612-373-3333"]];
    }
  } else if (indexPath.section == 2) {
    
    if (indexPath.row == 0) {
      [self composeEmail:@"beetlefight@gmail.com"];
    }
  }
}

-(void)dealloc {
  [super dealloc];
}

@end