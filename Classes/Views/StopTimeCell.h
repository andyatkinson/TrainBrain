//
//  StopTimeCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopTimeCell : UITableViewCell {
	UILabel *relativeTimeHour;
	UILabel *relativeTimeMinute;
	UILabel *scheduleTime;
	UILabel *price;
	UIImageView *icon;
}

@property (nonatomic, retain) UILabel *relativeTimeHour;
@property (nonatomic, retain) UILabel *relativeTimeMinute;
@property (nonatomic, retain) UILabel *scheduleTime;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UIImageView *icon;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
