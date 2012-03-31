//
//  Headsign.h
//  TrainBrain
//
//  Created by Aaron Batalion on 3/30/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Headsign : NSObject {
  NSString *headsign_key;
  NSString *headsign_public_name;
}

@property (nonatomic, retain) NSString *headsign_key;
@property (nonatomic, retain) NSString *headsign_public_name;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
