//
//  BigDepartureTableViewCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BigDepartureTableViewCell.h"

@implementation BigDepartureTableViewCell

@synthesize bigNumberLabel;
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = self.contentView;    
    
//    UIImageView *bgImageView = [[UIImageView alloc] init];
//    bgImageView.image = [UIImage imageNamed:@"bg_timer.png"];
    
    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bg_timer" ofType:@"png"]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setUserInteractionEnabled:NO];	
    self.backgroundView = imgView;
    
    //add the subView to the cell
    //[self.contentView addSubview:bgImageView];
    
    
    self.bigNumberLabel = [self newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
		self.bigNumberLabel.textAlignment = UITextAlignmentLeft; // default
		[contentView addSubview:self.bigNumberLabel];
		[self.bigNumberLabel release];
    
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void) setData:(NSDictionary *)dict {
	self.bigNumberLabel.text = [dict objectForKey:@"title"];
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
		frame = CGRectMake(boundsX + 10, 4, 200, 20);
		self.bigNumberLabel.frame = frame;
    
//    CGRect imageRectangle = CGRectMake(0.0f,0.0f,320.0f,44.0f); //cells are 44 px high
//    bgImageView.frame = imageRectangle;
    
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
	newLabel.backgroundColor = [UIColor whiteColor];
	newLabel.opaque = YES;
	newLabel.textColor = primaryColor;
	newLabel.highlightedTextColor = selectedColor;
	newLabel.font = font;
  
	return newLabel;
}

- (void)dealloc {
	[bigNumberLabel dealloc];
	[super dealloc];
}

@end
