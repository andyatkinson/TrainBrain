//
//  StationCell.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 8/23/10.
//  Copyright 2010 Beetle Fight. All rights reserved.
//

#import "StationCell.h"


@implementation StationCell

@synthesize stationName, subtitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
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
}


@end
