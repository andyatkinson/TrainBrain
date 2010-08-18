//
//  TrainLineCell.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TrainLineCell : UITableViewCell {
	IBOutlet UIImageView *lineImage;
	IBOutlet UILabel *lineTitle;
	IBOutlet UILabel *lineDescription;
	IBOutlet UIImageView *disclosureArrow;
}

@property (nonatomic, retain) IBOutlet UIImageView *lineImage;
@property (nonatomic, retain) IBOutlet UILabel *lineTitle;
@property (nonatomic, retain) IBOutlet UILabel *lineDescription;
@property (nonatomic, retain) IBOutlet UIImageView *disclosureArrow;

@end
