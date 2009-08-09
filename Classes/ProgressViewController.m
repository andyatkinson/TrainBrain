//
//  ProgressViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ProgressViewController.h"


@implementation ProgressViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
	self.title = @"Loading...";
  [super viewDidLoad];
	
	[activityIndicator startAnimating];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[activityIndicator dealloc];
}


@end
