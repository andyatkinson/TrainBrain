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
#import "MBProgressHUD.h"

@interface InfoViewController : UIViewController <UIWebViewDelegate> {
	NSURL *clickedLink;
	IBOutlet UIWebView *webView;
	TrainBrainAppDelegate *appDelegate;
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSURL *clickedLink;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) TrainBrainAppDelegate *appDelegate;


@end
