//
//  InfoDetailViewController.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "InfoDetailViewController.h"
#import "Info.h"

@implementation InfoDetailViewController

@synthesize infos, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadInfo {
  [Info infoDetailURLEndpoint:@"/info/hiawatha" parameters:nil block:^(NSArray *data) {
    
    
    self.infos = data;
    
    [self loadHTML];
    
  }];
}

-(void) loadHTML {  
  
  if ([self.infos count] > 0) {
    Info *info = (Info *)[self.infos objectAtIndex:0];
    [self.webView loadHTMLString:info.detail baseURL:nil];
  }
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.infos = [[NSArray alloc] init];
  
  [self loadInfo];
  
  self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, 260)];
  self.webView.delegate = self;
  
  self.view = self.webView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
