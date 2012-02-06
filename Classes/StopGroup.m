//
//  StopGroup.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 2/5/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopGroup.h"
#import "TransitAPIClient.h"
#import "Stop.h"

@implementation StopGroup

@synthesize stops, name;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.name = [attributes valueForKeyPath:@"name"];
    self.stops = [Stop stopsFromArray:[attributes valueForKeyPath:@"stops"]];
    
    return self;
}

@end
