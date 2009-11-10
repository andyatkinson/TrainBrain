//
//  ProgressViewController.m
//  train brain
//
//  Created by Andy Atkinson on 7/1/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

#import "ProgressViewController.h"

@implementation ProgressViewController

@synthesize activityIndicator, loadingLabel, message;

- (void)viewDidLoad {	
  [super viewDidLoad];
	[self.loadingLabel setText:message];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) startProgressIndicator {
	[activityIndicator startAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void) stopProgressIndicator {
	[activityIndicator stopAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	// this doesn't really happen unless a low memory situation?
	[activityIndicator stopAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)dealloc {
	[super dealloc];
	[activityIndicator release];
	[loadingLabel release];
}


@end
