//
//  Route.m
//  TrainBrain
//
//  Created by Andrew Atkinson on 12/2/11.
//  Copyright 2011 Beetle Fight. All rights reserved.
//

#import "Route.h"
#import "TransitAPIClient.h"

@implementation Route

@synthesize route_id, long_name, short_name, route_desc, route_type, route_url;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.route_id = [attributes valueForKeyPath:@"route_id"];
    self.long_name = [attributes valueForKeyPath:@"long_name"];
    self.short_name = [attributes valueForKeyPath:@"short_name"];
    self.route_desc = [attributes valueForKeyPath:@"route_desc"];
    self.route_type = [attributes valueForKeyPath:@"route_type"];
    self.route_url = [attributes valueForKeyPath:@"route_url"];
    
    return self;
}

+ (void)routesWithURLString:(NSString *)urlString near:(CLLocation *)location parameters:(NSDictionary *)parameters block:(void (^)(NSArray *records))block {
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[TransitAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableRecords = [NSMutableArray array];
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"routes"]) {
            Route *route = [[[Route alloc] initWithAttributes:attributes] autorelease];
            [mutableRecords addObject:route];
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

@end

