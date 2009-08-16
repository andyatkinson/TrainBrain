//
//  DepartureDetailCell.m
//  TrainBrain
//
//  Created by Andy Atkinson on 7/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DepartureDetailCell.h"


@implementation DepartureDetailCell

@synthesize departureTime, departureCost, timeRemaining, type;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
	[departureTime dealloc];
	[departureCost dealloc];
	[timeRemaining dealloc];
}


@end
