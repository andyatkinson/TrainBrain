//
//  BigDepartureTableViewCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BigDepartureTableViewCell.h"
#import "StopTime.h"

@implementation BigDepartureTableViewCell

@synthesize countDownTimer     = _countDownTimer;
@synthesize countDownStartDate = _countDownStartDate;
@synthesize stopDate           = _stopDate;
@synthesize bigDepartureHour, bigDepartureMinute, bigDepartureSeconds;
@synthesize bigDepartureHourUnit, bigDepartureMinuteUnit, bigDepartureSecondsUnit;
@synthesize funnySaying, description, formattedTime, price;

- (void) startTimer {
  if([self countDownTimer] == nil){
    NSLog(@"Start Timer");
    [self setCountDownStartDate:[NSDate date]];
    
    // Create the stop watch timer that fires every 1 s
    [self setCountDownTimer: [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES]];
  }
}

- (void) stopTimer {
  [[self countDownTimer] invalidate];
  [self setCountDownTimer: nil];
}

- (void) setStopTime: (StopTime*) stopTime {  
  //Gives us the current date
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[self stopDate]];
  [components setHour:stopTime.departure_time_hour];
  [components setMinute:stopTime.departure_time_minute];
  [components setSecond:0];
  
  [self setStopDate:[gregorian dateFromComponents:components]];
  [gregorian release];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh:mm a"];
  self.formattedTime.text = [dateFormatter stringFromDate:[self stopDate]];
  self.price.text         = stopTime.price;
  
}

- (void)updateTimer {
  NSDate *currentDate = [NSDate date];
  NSTimeInterval timeInterval = [[self stopDate] timeIntervalSinceDate:currentDate];
  NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
  NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:timerDate];
  NSInteger hour    = [components hour];
  NSInteger minute  = [components minute];
  NSInteger seconds = [components second];
  
  self.bigDepartureHour.text    = [NSString stringWithFormat:@"%02d", hour];
  self.bigDepartureMinute.text  = [NSString stringWithFormat:@"%02d", minute];
  self.bigDepartureSeconds.text = [NSString stringWithFormat:@"%02d", seconds];
  
  if(hour == 0){
    [self layoutTimer:false];
  } else {
    [self layoutTimer:true];
  }
  
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = self.contentView;    
    
    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"bg_timer" ofType:@"png"]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setUserInteractionEnabled:NO];	
    self.backgroundView = imgView;
    
    self.bigDepartureHour    = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES];
    self.bigDepartureMinute  = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES];
    self.bigDepartureSeconds = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:70.0 bold:YES];
    
    self.bigDepartureHourUnit    = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];
    self.bigDepartureMinuteUnit  = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];
    self.bigDepartureSecondsUnit = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:30.0 bold:YES];
    
    self.funnySaying = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:YES];
    self.description = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:YES];
    self.formattedTime = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO];
    self.price = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12.0 bold:NO];
    
		[contentView addSubview:self.bigDepartureHour];
    [contentView addSubview:self.bigDepartureMinute];
    [contentView addSubview:self.bigDepartureSeconds];
    
    [contentView addSubview:bigDepartureHourUnit];
    [contentView addSubview:bigDepartureMinuteUnit];
    [contentView addSubview:bigDepartureSecondsUnit];
    
    [contentView addSubview:self.funnySaying];
    [contentView addSubview:self.description];
    [contentView addSubview:self.formattedTime];
    [contentView addSubview:self.price];
		
    [self.bigDepartureHour release];
    [self.bigDepartureMinute release];
    [self.bigDepartureSeconds release];
    [self.funnySaying release];
    [self.description release];
    [self.formattedTime release];
    [self.price release];
    
    self.bigDepartureHour.text    = @"--";
    self.bigDepartureMinute.text  = @"--";
    self.bigDepartureSeconds.text = @"--";
    
    self.bigDepartureHourUnit.text    = @"h";
    self.bigDepartureMinuteUnit.text  = @"m";
    self.bigDepartureSecondsUnit.text = @"s";
    
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void) setData:(NSDictionary *)dict {
	self.bigDepartureHour.text = [dict objectForKey:@"title"];
}

- (void) layoutTimer:(BOOL) showHours {
  CGRect contentRect = self.contentView.bounds;
  CGFloat boundsX    = contentRect.origin.x;
  
  if(showHours){
    self.bigDepartureHour.frame        = CGRectMake(boundsX +  10,   0, 300, 100);
    self.bigDepartureHourUnit.frame    = CGRectMake(boundsX +  88,  14, 300, 100);
    self.bigDepartureMinute.frame      = CGRectMake(boundsX + 108,   0, 300, 100);
    self.bigDepartureMinuteUnit.frame  = CGRectMake(boundsX + 185,  14, 300, 100);
    self.bigDepartureSeconds.frame     = CGRectMake(boundsX + 214,   0, 300, 100);
    self.bigDepartureSecondsUnit.frame = CGRectMake(boundsX + 290,  14, 300, 100);
  } else {
    self.bigDepartureHour.frame        = CGRectMake(boundsX - 100,   0, 300, 100);
    self.bigDepartureHourUnit.frame    = CGRectMake(boundsX - 100,  14, 300, 100);
    self.bigDepartureMinute.frame      = CGRectMake(boundsX +  70,   0, 300, 100);
    self.bigDepartureMinuteUnit.frame  = CGRectMake(boundsX + 148,  14, 300, 100);
    self.bigDepartureSeconds.frame     = CGRectMake(boundsX + 180,   0, 300, 100);
    self.bigDepartureSecondsUnit.frame = CGRectMake(boundsX + 258,  14, 300, 100);
  }
  
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
	// getting the cell size
  CGRect contentRect = self.contentView.bounds;
  
	// In this example we will never be editing, but this illustrates the appropriate pattern
  if (!self.editing) {
    [self layoutTimer:false];
    
		// get the X pixel spot
    CGFloat boundsX = contentRect.origin.x;    
    self.funnySaying.frame   = CGRectMake(boundsX +  20,  98, 200,  20);
		self.description.frame   = CGRectMake(boundsX +  20, 115, 200,  20);
		self.formattedTime.frame = CGRectMake(boundsX + 250,  95,  80,  20);
		self.price.frame         = CGRectMake(boundsX + 250, 115,  80,  20);
    
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
