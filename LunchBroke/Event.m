//
//  Event.m
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "Event.h"

@implementation Event

@dynamic eventName;
@dynamic location;
@dynamic timeOfEvent;
@dynamic Attendees;
@dynamic manager;
@dynamic objectId;
@dynamic imageName;
@dynamic imageLabel;
@synthesize attendeesArray;



+ (NSString *)parseClassName
{
    return @"Event";
}

@end
