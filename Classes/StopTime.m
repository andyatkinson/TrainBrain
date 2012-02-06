//
//  StopTime.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "StopTime.h"
#import "TransitAPIClient.h"
#import "TimeEntry.h"

@implementation StopTime

@synthesize departure_time, arrival_time, drop_off_type, pickup_type, price, headsign, headsign_key;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.departure_time = [attributes valueForKeyPath:@"departure_time"];
    self.arrival_time = [attributes valueForKeyPath:@"arrival_time"];
    self.drop_off_type = [attributes valueForKeyPath:@"drop_off_type"];
    self.pickup_type = [attributes valueForKeyPath:@"pickup_type"];
    self.price = [attributes valueForKeyPath:@"price"];
    self.headsign = [attributes valueForKey:@"headsign"];
    self.headsign_key = [attributes valueForKey:@"headsign_key"];
    
    return self;
}

+ (void)stopTimesWithURLString:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSArray *records))block {
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableRecords = [NSMutableArray array];
        
        TimeEntry *te = [[[TimeEntry alloc] initWithAttributes:[JSON valueForKeyPath:@"time_entry"]] autorelease];
        [mutableRecords addObject:te];
        
        if (block) {
            block([NSArray arrayWithArray:mutableRecords]);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array]);
        }
    }];
}

+ (NSArray *)stopTimesFromArray:(NSArray *)array {
    NSMutableArray *mutableRecords = [NSMutableArray array];
    for (NSDictionary *attributes in array) {
        StopTime *st = [[[StopTime alloc] initWithAttributes:attributes] autorelease];
        [mutableRecords addObject:st];
    }
    
    return mutableRecords;
}

@end
