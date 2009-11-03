//
//  TrainBrainAppDelegate.h
//  train brain
//
//  Created by Andy Atkinson on 6/22/09.
//  Copyright 2009 Andy Atkinson http://webandy.com. All rights reserved.
//

@interface TrainBrainAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;

	NSString *line;
	NSString *headsign;
	NSMutableArray *stopIds;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (void) setLine:(NSString *)selectedLine;
- (NSString *) getLine;

- (void) setHeadsign:(NSString *)selectedHeadsign;
- (NSString *) getHeadsign;

- (void) addStopId:(NSString *)newStopId;
- (NSArray *) getStopIds;

@end

