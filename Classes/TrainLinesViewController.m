// Copyright statement here

#import "TrainLinesViewController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"
#import "CustomCell.h"

@interface TrainLinesViewController (Private)
- (void)loadTrainLines;
@end

@implementation TrainLinesViewController

@synthesize trainLinesTableView, views, lines, responseData, locationManager, startingPoint, 
progressViewController, mapURL;

- (void) loadTrainLines {
	ProgressViewController *pvc = [[ProgressViewController alloc] init];
	pvc.message = @"Loading Train Lines...";
	self.progressViewController = pvc;
	[self.view addSubview:pvc.view];
	
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
	
	// kick off the request, the view is reloaded from the location update code
}


-(IBAction)refreshTrainLines:(id)sender {
	[self loadTrainLines];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"viewDidLoad of train lines view controller");
	
	[self loadTrainLines];
	
	// TODO is this used?
	responseData = [[NSMutableData data] retain];
	
	// Set the Lines back button
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"Lines";
	self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	// set the title of the main navigation
	self.title = @"train brain";
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];  // move responseData var here?
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network connection failed. \n\n Ensure Airplane Mode is not enabled and a network connection is available." 
																									message:nil 
																								 delegate:nil 
																				cancelButtonTitle:@"OK" 
																				otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJSON *parser = [[SBJSON alloc] init];
	// parse the JSON response into an object
	NSArray *lines = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	views = [[NSMutableArray alloc] init];
	int count = [lines count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSMutableDictionary *line = [lines objectAtIndex:i];
			NSString *lineName = [line objectForKey:@"name"];
			TrainLinesViewController *trainLinesViewController = [[TrainLinesViewController alloc] init];

			[trainLinesViewController release];
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Train Lines Found.\n\nPlease try tapping the refresh button." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	// IMPORTANT: this call reloads the UITableView cells data after the data is available
	[trainLinesTableView reloadData];
	
	self.title = @"Tap a train line";
	// remove the modal view, now that the location has been calculated
	[progressViewController.view	removeFromSuperview];
}


// Location delegaate code TODO: should this be in another view controller?
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if(startingPoint == nil)
		self.startingPoint = newLocation;
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"http://localhost:3000/rail_stations.json?ll=%g,%g", 
															newLocation.coordinate.latitude, 
															newLocation.coordinate.longitude];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[locationString release];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[progressViewController.view	removeFromSuperview];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"train brain requires location data to display train stations sorted by distance." 
																									message:nil 
																								 delegate:nil 
																				cancelButtonTitle:@"OK" 
																				otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	// Unselect the selected row if any
	NSIndexPath*	selection = [trainLinesTableView indexPathForSelectedRow];
	if (selection) {
		[trainLinesTableView deselectRowAtIndexPath:selection animated:YES];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
	if (cell == nil) {  
		cell = [[[CustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];  
	}  
	
	// Set up the cell...  TODO use the regular cell
	cell.titleLabel.text = [[views objectAtIndex:indexPath.row] objectForKey:@"name"];
//	NSString *distanceString = [NSString stringWithFormat:@"%@", [[views objectAtIndex:indexPath.row] objectForKey:@"distance"]];
//	cell.distanceLabel.text = distanceString;
	
	return cell;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// push the directions view controller
	
	//TimeEntryController *targetViewController = (TimeEntryController *)[[views objectAtIndex: indexPath.row] objectForKey:@"controller"];
	// trying a crazy hack to read the value of StationsViewController.southbound and set it on TimeEntryController.southbound
	// maybe need a Singleton pattern here but couldn't figure it out TODO FIXME
	//[targetViewController setSouthbound:[self southbound]];
	

	
	//[[self navigationController] pushViewController:targetViewController animated:YES];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	// TODO dealloc stuff here
}


@end
