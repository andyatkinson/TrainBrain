//
//  StationCell.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 8/23/10.
//  Copyright 2010 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StationCell : UITableViewCell {
	IBOutlet UILabel *stationName;
	IBOutlet UILabel *subtitle;

}

@property (nonatomic, retain) IBOutlet UILabel *stationName;
@property (nonatomic, retain) IBOutlet UILabel *subtitle;


@end
