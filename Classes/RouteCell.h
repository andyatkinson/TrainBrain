//
//  RouteCell.h
//  TrainBrain
//
//  Created by Aaron Batalion on 3/14/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell {
  UILabel *routeTitle;
  UILabel *routeDescription;
  UILabel *extraInfo;
  UIImageView *routeIcon;
}

@property (nonatomic, retain) UILabel *routeTitle;
@property (nonatomic, retain) UILabel *routeDescription;
@property (nonatomic, retain) UILabel *extraInfo;
@property (nonatomic, retain) UIImageView *routeIcon;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
