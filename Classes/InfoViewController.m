//
//  InfoViewController.m
//  TrainBrain
//
//  Created by Andy Atkinson on 1/10/10.
//  Copyright 2010 http://webandy.com. All rights reserved.
//

#import "InfoViewController.h"
#import "TrainBrainAppDelegate.h"

@implementation InfoViewController

@synthesize webView, appDelegate;

- (void)viewDidLoad {
	self.title = @"Help";
	
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked:)];
	self.navigationItem.rightBarButtonItem = backButton;
	[backButton release];
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"%@info", [appDelegate getBaseUrl]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(IBAction)backButtonClicked:(id)sender {
	[webView goBack];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[webView release];
}


@end

