//
//  StopTimeCell.h
//  TrainBrain
//
//  Created by Aaron Batalion on 3/31/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopTimeCell : UITableViewCell {
  UILabel *relativeTime;
  UILabel *scheduleTime;
  UILabel *price;
  UIImageView *icon;
}

@property (nonatomic, retain) UILabel *relativeTime;
@property (nonatomic, retain) UILabel *scheduleTime;
@property (nonatomic, retain) UILabel *price;
@property (nonatomic, retain) UIImageView *icon;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
