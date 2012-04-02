//
//  StopTimeCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopTimeCell.h"

@implementation StopTimeCell

@synthesize relativeTime, scheduleTime, price, icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = self.contentView;
    
    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.backgroundView = [[UIImageView alloc] initWithImage:bgImg];
    
    self.icon = [[ UIImageView alloc ] init];
    self.relativeTime = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];
    self.scheduleTime = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:NO];
    self.price = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:NO];
    
    
    [contentView addSubview:self.icon];
		[contentView addSubview:self.relativeTime];
    [contentView addSubview:self.scheduleTime];
    [contentView addSubview:self.price];
    
		[self.icon release];
    [self.relativeTime release];
    [self.scheduleTime release];
    [self.price release];
  }
  
  return self;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
	// getting the cell size
  CGRect contentRect = self.contentView.bounds;
  
	// In this example we will never be editing, but this illustrates the appropriate pattern
  if (!self.editing) {
    
		// get the X pixel spot
    CGFloat boundsX = contentRect.origin.x;
		CGRect frame;
    
    /*
		 Place the label.
		 place the label whatever the current X is plus 10 pixels from the left
		 place the label 4 pixels from the top
		 make the label 200 pixels wide
		 make the label 20 pixels high
     */
    frame = CGRectMake(boundsX + 10, 18, 20, 20);
    self.icon.frame = frame;
    
		frame = CGRectMake(boundsX + 50, 12, 80, 30);
		self.relativeTime.frame = frame;
    
    frame = CGRectMake(boundsX + 140, 5, 80, 50);
    self.scheduleTime.frame = frame;
    
    frame = CGRectMake(boundsX + 239, 5, 50, 50);
    self.price.frame = frame;

    
	}
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
	/*
	 Create and configure a label.
	 */
  
  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }
  
  /*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
	 */
	UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	newLabel.backgroundColor = [UIColor clearColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
  newLabel.lineBreakMode = UILineBreakModeTailTruncation;
  
	return newLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
