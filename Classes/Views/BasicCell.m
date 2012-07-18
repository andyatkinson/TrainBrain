//
//  BasicCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BasicCell.h"

@implementation BasicCell

@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    self.accessoryType = UITableViewCellAccessoryNone;
    
    UIView *myContentView = self.contentView;
    myContentView.backgroundColor = [UIColor blackColor];
    self.titleLabel = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor clearColor] fontSize:14.0 bold:YES];
    self.titleLabel.textAlignment = UITextAlignmentLeft;
    [myContentView addSubview:self.titleLabel];
    [self.titleLabel release];
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	if(!self.editing) {
		CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
		frame = CGRectMake(boundsX + 16, 4, 280, 20);
		self.titleLabel.frame = frame;
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
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
	return newLabel;
}


- (void)dealloc {
	[super dealloc];
	[titleLabel dealloc];
}

@end
