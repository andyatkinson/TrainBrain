//
//  BigDepartureTableViewCell.h
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigDepartureTableViewCell : UITableViewCell {
  UILabel *bigDeparture;
  UILabel *funnySaying;
  UILabel *description;
  UILabel *formattedTime;
  UILabel *price;
  
}

@property (nonatomic, retain) UILabel *bigDeparture;
@property (nonatomic, retain) UILabel *funnySaying;
@property (nonatomic, retain) UILabel *description;
@property (nonatomic, retain) UILabel *formattedTime;
@property (nonatomic, retain) UILabel *price;

// these are the functions we will create in the .m file

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
