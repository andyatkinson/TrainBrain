//
//  Stop.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/3/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "Stop.h"
#import "StopGroup.h"
#import "TransitAPIClient.h"

@implementation Stop

@synthesize stop_id, stop_name, stop_street, stop_lat, stop_lon, stop_city, stop_desc, location;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.stop_name = [attributes valueForKeyPath:@"stop_name"];
    self.stop_id = [attributes valueForKeyPath:@"stop_id"];
    self.stop_desc = [attributes valueForKeyPath:@"stop_desc"];
    self.stop_lat = [attributes valueForKeyPath:@"stop_lat"];
    self.stop_lon = [attributes valueForKeyPath:@"stop_lon"];
    self.stop_city = [attributes valueForKey:@"stop_city"];
    self.location = [[CLLocation alloc] initWithLatitude:self.stop_lat.floatValue longitude:self.stop_lon.floatValue];
    
    return self;
}

+ (void)stopsWithURLString:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSArray *records))block {
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableRecords = [NSMutableArray array];
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"stop_groups"]) {
            StopGroup *group = [[[StopGroup alloc] initWithAttributes:attributes] autorelease];
            [mutableRecords addObject:group];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutableRecords]);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array]);
        }
    }];
}

+ (NSArray *)stopsFromArray:(NSArray *)array {
    NSMutableArray *mutableRecords = [NSMutableArray array];
    for (NSDictionary *attributes in array) {
        Stop *stop = [[[Stop alloc] initWithAttributes:attributes] autorelease];
        [mutableRecords addObject:stop];
    }
    
    return mutableRecords;
}


@end
