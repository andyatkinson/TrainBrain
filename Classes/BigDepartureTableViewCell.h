//
//  BigDepartureTableViewCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigDepartureTableViewCell : UITableViewCell {
  UILabel *bigNumberLabel;
}

@property (nonatomic, retain) UILabel *bigNumberLabel;

// these are the functions we will create in the .m file

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
