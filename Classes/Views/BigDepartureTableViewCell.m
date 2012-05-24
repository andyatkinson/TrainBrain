//
//  BigDepartureTableViewCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BigDepartureTableViewCell.h"

@implementation BigDepartureTableViewCell

@synthesize bigDepartureHour, bigDepartureMinute, funnySaying, description, formattedTime, price;

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
    
    self.bigDepartureHour = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:60.0 bold:YES];
    self.bigDepartureMinute = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:60.0 bold:YES];
    self.funnySaying = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
    self.description = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:YES];
    self.formattedTime = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO];
    self.price = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO];
    
		[contentView addSubview:self.bigDepartureHour];
    [contentView addSubview:self.bigDepartureMinute];
    [contentView addSubview:self.funnySaying];
    [contentView addSubview:self.description];
    [contentView addSubview:self.formattedTime];
    [contentView addSubview:self.price];
		
    [self.bigDepartureHour release];
    [self.bigDepartureMinute release];
    [self.funnySaying release];
    [self.description release];
    [self.formattedTime release];
    [self.price release];
    
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void) setData:(NSDictionary *)dict {
	self.bigDepartureHour.text = [dict objectForKey:@"title"];
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
		frame = CGRectMake(boundsX + 60, 0, 300, 100);
		self.bigDepartureHour.frame = frame;
    
    frame = CGRectMake(boundsX + 170, 0, 300, 100);
		self.bigDepartureMinute.frame = frame;
    
    frame = CGRectMake(boundsX + 20, 98, 200, 20);
		self.funnySaying.frame = frame;
    
    frame = CGRectMake(boundsX + 20, 115, 200, 20);
		self.description.frame = frame;
    
    frame = CGRectMake(boundsX + 250, 95, 80, 20);
		self.formattedTime.frame = frame;
    
    frame = CGRectMake(boundsX + 250, 115, 80, 20);
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
  
	return newLabel;
}

- (void)dealloc {
	[bigDepartureHour dealloc];
  [bigDepartureMinute dealloc];
  [funnySaying dealloc];
  [description dealloc];
  [formattedTime dealloc];
  [price dealloc];
	[super dealloc];
}

@end