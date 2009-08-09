//
//  CustomCell.h
//  TrainBrain
//
//  Created by Andy Atkinson on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *distanceLabel;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *distanceLabel;

@end
