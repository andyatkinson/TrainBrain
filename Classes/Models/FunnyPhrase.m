//
//  FunnyPhrase.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "FunnyPhrase.h"

@implementation FunnyPhrase

+ (NSString *)rand { 
  NSArray *phrases = [NSArray arrayWithObjects:@"Hurry Up. No Shoving.", @"Don't drop your phone.", @"You look nice today.", @"I average 18mph.", @"I saved you a seat", @"Bad day?", @"Cars are so over.", @"Giddy up", @"Mind the gap", @"You come here often?", @"Go LRT or go home", @"Public transit FTW", @"Northstar is the best star", @"What, you've never been late?", @"Aren't you happy to see me?", @"Why so serious?", @"Got a tic tac?", @"Chugga chugga choo choo", @"I think I can, I think I can", @"I <3 bikes!", @"Oil is so over.", nil];
  
  NSUInteger randomIndex = arc4random() % [phrases count];
  return (NSString *)[phrases objectAtIndex:randomIndex];
}

@end
