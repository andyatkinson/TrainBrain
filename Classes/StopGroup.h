//
//  StopGroup.h
//  TrainBrain
//
//  Created by Andrew Atkinson on 2/5/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopGroup : NSObject {
    NSArray *stops;
    NSString *name;
}

@property (nonatomic, retain) NSArray *stops;
@property (nonatomic, retain) NSString *name;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
