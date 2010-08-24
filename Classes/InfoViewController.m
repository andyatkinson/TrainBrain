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

@synthesize clickedLink, webView, appDelegate;

- (void)viewDidLoad {
	self.title = @"Help";
	
	appDelegate =	(TrainBrainAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSString *locationString = [[NSString alloc] initWithFormat:@"%@info", [appDelegate getBaseUrl]];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:locationString]];
	[webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

{
	NSURL *loadURL = [[request URL] retain];
	
	// Check navigationType. Else this alert will be visible on every load of UIWebView 
	if ( ([[loadURL scheme] isEqualToString: @"http"] || [[loadURL scheme] isEqualToString: @"https" ]) && (navigationType == UIWebViewNavigationTypeLinkClicked) )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leave Train Brain?" 
																									 message :@"Load link in the web browser by pressing Yes, or press No to stay on this screen."
																									 delegate:self 
																					cancelButtonTitle: @"No"
																					otherButtonTitles:@"Yes", nil];
		
		[alert show];
		[alert release];
		
		clickedLink = [[request URL] retain];
		
		[loadURL release];
	} 
	else
	{
		[loadURL release];
		return YES;
	}
	return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1)
	{
		[[UIApplication sharedApplication] openURL:clickedLink];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
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

