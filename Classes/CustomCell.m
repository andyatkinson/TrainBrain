//
//  CustomCell.m
//  TrainBrain
//
//  Created by Andy Atkinson on 6/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize titleLabel, distanceLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
			self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			UIView *myContentView = self.contentView;
			self.titleLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor blackColor] fontSize:20.0 bold:YES];
			self.titleLabel.textAlignment = UITextAlignmentLeft;
			[myContentView addSubview:self.titleLabel];
			[self.titleLabel release];
			
			self.distanceLabel = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor grayColor] fontSize:10.0 bold:NO];
			self.distanceLabel.textAlignment = UITextAlignmentLeft;
			[myContentView addSubview:self.distanceLabel];
			[self.distanceLabel release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// assembling the custom cell http://iphone.zcentric.com/2008/08/05/custom-uitableviewcell/
- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	if(!self.editing) {
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		frame = CGRectMake(boundsX + 10, 4, 240, 20);
		self.titleLabel.frame = frame;
		
		frame = CGRectMake(boundsX + 10, 25, 240, 14);
		self.distanceLabel.frame = frame;
	}
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold {
	UIFont *font;
	if (bold) {
		font = [UIFont boldSystemFontOfSize:fontSize];
	} else {
		font = [UIFont systemFontOfSize:fontSize];
	}
	
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	
	return newLabel;
}


- (void)dealloc {
    [super dealloc];
	[titleLabel dealloc];
	[distanceLabel dealloc];
}


@end
