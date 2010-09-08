//
//  YellowGradient.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 9/6/10.
//  Copyright 2010 Beetle Fight. All rights reserved.
//

#import "YellowGradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation YellowGradientView

//
// layerClass
//
// returns a CAGradientLayer class as the default layer class for this view
//
+ (Class)layerClass
{
	return [CAGradientLayer class];
}

//
// setupGradientLayer
//
// Construct the gradient for either construction method
//

- (void)setupGradientLayer
{
	CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
	gradientLayer.colors =
	[NSArray arrayWithObjects:
	 (id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor,
	 (id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1.0].CGColor,
	 nil];
	self.backgroundColor = [UIColor clearColor];
}

//
// initWithFrame:
//
// Initialise the view.
//
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
		gradientLayer.colors =
		[NSArray arrayWithObjects:
		 (id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor,
		 (id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1.0].CGColor,
		 nil];
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}


@end
