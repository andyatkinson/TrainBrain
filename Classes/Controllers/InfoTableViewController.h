//
//  InfoTableViewController.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate> {
  NSMutableArray *dataArrays;
  UITableView *tableView;
}

@property (nonatomic, retain) NSMutableArray *dataArrays;
@property (nonatomic, retain) UITableView *tableView;

- (void)composeEmail:(NSString *)emailAddr;


@end
