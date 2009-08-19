//
//  ProgressViewController.h
//  TrainBrain
//
//  Created by Andy Atkinson on 7/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgressViewController : UIViewController {
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString *message;
	IBOutlet UILabel *loadingLabel;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet NSString *message;

@end
