//
//  InfoViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 1/10/10.
//  Copyright 2010 http://webandy.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>
#import "TrainBrainAppDelegate.h"

@interface InfoViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	TrainBrainAppDelegate *appDelegate;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;

-(IBAction)backButtonClicked:(id)sender;

@end
