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
    [super didReceiveMemoryWarning];
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
