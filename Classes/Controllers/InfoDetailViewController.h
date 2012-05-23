//
//  InfoDetailViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoDetailViewController : UIViewController {
  NSArray *infos;
  UIWebView *webView;
}

@property (nonatomic, retain) NSArray *infos;
@property (nonatomic, retain) UIWebView *webView;

- (void)loadInfo;

@end
