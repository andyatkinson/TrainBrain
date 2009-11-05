//
//  StopAnnotation.h
//  TrainBrain
//
//  Created by Andy Atkinson on 9/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@class Stop;

@interface StopAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D _coordinate;
	NSString *_title;
	NSString *_subtitle;
	Stop *_stop;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) Stop *stop;

+(id)annotationWithStop:(Stop *)stop;
-(id)initWithStop:(Stop *)stop;

@end
