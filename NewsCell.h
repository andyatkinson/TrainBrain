//
//  NewsCell.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 8/23/10.
//  Copyright 2010 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsCell : UITableViewCell {
	IBOutlet UIImageView *avatarUrl;
	IBOutlet UILabel *title;
	IBOutlet UILabel *published;
	IBOutlet UILabel *author;
}

@property (nonatomic, retain) IBOutlet UIImageView *avatarUrl;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *published;
@property (nonatomic, retain) IBOutlet UILabel *author;

@end
