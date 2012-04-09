//
//  FunnyPhrase.m
//  TrainBrain
//
//  Created by Aaron Batalion on 4/9/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "FunnyPhrase.h"

@implementation FunnyPhrase

+ (NSString *)rand { 
  NSArray *phrases = [NSArray arrayWithObjects:@"Hurry Up. No Shoving.", @"Don't forget your phone.", @"Good story. Now hop on.", @"Don't worry, I'm almost there.", @"You look nice today.", @"Where did you get those shoes?", @"I have 19 stops. How many do you have?", @"Hang tight. I only average 18mph.", nil];
  
  NSUInteger randomIndex = arc4random() % [phrases count];
  return (NSString *)[phrases objectAtIndex:randomIndex];
}

@end
