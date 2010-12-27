//
//  NewsViewController.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/26/10.
//  Copyright 2010 Beetle Fight. All rights reserved.
//

#import "NewsViewController.h"
#import "JSON/JSON.h"
#import "TrainBrainAppDelegate.h"
#import "QuartzCore/QuartzCore.h"

@implementation NewsViewController

@synthesize views, responseData, newsTableView, appDelegate;

- (void) loadNewsStories {
	HUD.labelText = @"Loading";
	HUD.detailsLabelText = @"News";
	
	NSString *requestURL = [NSString stringWithFormat:@"%@news.json", [appDelegate getBaseUrl]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//
// Hack to add 1px header/footer around tableview to prevent separator rows from showing
// See: http://stackoverflow.com/questions/1369831/eliminate-extra-separators-below-uitableview-in-iphone-sdk
// 
- (void) addHeaderAndFooter
{
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	v.backgroundColor = [UIColor clearColor];
	[self.newsTableView setTableHeaderView:v];
	[self.newsTableView setTableFooterView:v];
	[v release];
}

- (void)viewDidLoad {		
	[super viewDidLoad];
	
	// prevent table view separator from showing on empty cells
	[self addHeaderAndFooter];
	
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	responseData = [[NSMutableData data] retain];
	
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	HUD = [[MBProgressHUD alloc] initWithWindow:window];
	[window addSubview:HUD];
	HUD.delegate = self;
	
	[self loadNewsStories];
	self.title = @"News";
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[HUD hide:YES];
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
	NSArray *newsItems = [parser objectWithString:responseString error:nil];
	[parser release];
	[responseString release];
	views = [[NSMutableArray alloc] init];
	int count = [newsItems count];
	if(count > 0) {
		for(int i=0; i < count; i++) {
			NSMutableDictionary *item = [newsItems objectAtIndex:i];
			
			NSString *avatarUrl = [item objectForKey:@"avatar_url"];
			NSString *entryTitle = [item objectForKey:@"title"];
			NSString *entryAuthor = [item objectForKey:@"author"];
			NSString *entryPublished = [item objectForKey:@"published"];
			[views addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
												avatarUrl, @"avatarUrl",
												entryTitle, @"title",
												entryPublished, @"published",
												entryAuthor, @"author",
												nil]];
			
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No News Stories Found." 
																										message:nil 
																									 delegate:nil 
																					cancelButtonTitle:@"OK" 
																					otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	// IMPORTANT: this call reloads the UITableView cells data after the data is available
	[newsTableView reloadData];
	
	[HUD hide:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	
	// Unselect the selected row if any
	NSIndexPath*	selection = [newsTableView indexPathForSelectedRow];
	if (selection) {
		[newsTableView deselectRowAtIndexPath:selection animated:YES];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [views count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"NewsCell";
	
	NewsCell *cell = (NewsCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:nil options:nil];
	
	for(id currentObject in nibObjects) {
		if([currentObject isKindOfClass:[NewsCell class]]) {
			cell = (NewsCell *)currentObject;
		}
	}
	
	if([views count] > 0) {
		
		NSURL *url = [NSURL URLWithString:[[views objectAtIndex:indexPath.row] objectForKey:@"avatarUrl"]];
		
		UIImageView *roundedCorners = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
		roundedCorners.center = self.view.center;
		roundedCorners.layer.cornerRadius = 20.0;
		roundedCorners.layer.masksToBounds = YES;
		roundedCorners.layer.borderColor = [UIColor lightGrayColor].CGColor;
		roundedCorners.layer.borderWidth = 1.0;
		
		[[cell avatarUrl] setImage:roundedCorners.image];
		
		[[cell title] setText:[[views objectAtIndex:indexPath.row] objectForKey:@"title"]];
		[[cell published] setText:[[views objectAtIndex:indexPath.row] objectForKey:@"published"]];
		[[cell author] setText:[[views objectAtIndex:indexPath.row] objectForKey:@"author"]];
		cell.backgroundView = [[[GradientView alloc] init] autorelease];
	}
	
	return cell;
}


// set the table view cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// do I need to set this if the height is specified in IB?
	return 90;
}

- (void)hudWasHidden
{
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
