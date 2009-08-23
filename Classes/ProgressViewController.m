//
//  ProgressViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProgressViewController.h"

@implementation ProgressViewController

@synthesize activityIndicator, loadingLabel, message;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
  [super viewDidLoad];
	[self.loadingLabel setText:message];
	[activityIndicator startAnimating];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[activityIndicator stopAnimating];
}


- (void)dealloc {
	[super dealloc];
	[activityIndicator release];
	[loadingLabel release];
}


@end
