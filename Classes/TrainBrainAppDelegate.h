//
//  TrainBrainAppDelegate.h
//  TrainBrain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

@interface TrainBrainAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    UINavigationController *navigationController;
}

- (IBAction)saveAction:sender;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

