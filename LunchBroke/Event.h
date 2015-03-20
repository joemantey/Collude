//
//  Event.h
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Locations;

@interface Event : NSObject

@property  (strong, nonatomic) NSString *eventName;
@property  (strong, nonatomic) Locations *location;
@property (nonatomic) NSDate *time;


@end
