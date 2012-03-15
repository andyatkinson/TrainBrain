//
//  RouteCell.h
//  TrainBrain
//
//  Created by Aaron Batalion on 3/14/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell {
  UILabel *routeTitleLabel;
}

@property (nonatomic, retain) UILabel *routeTitleLabel;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
