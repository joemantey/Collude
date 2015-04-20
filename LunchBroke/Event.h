//
//  Event.h
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class Locations;

@interface Event : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) Locations *location;
@property (nonatomic) NSDate *timeOfEvent;
@property (strong, nonatomic) PFRelation *Attendees;
@property (strong, nonatomic) PFUser *manager;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *imageLabel;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSArray *coordinates;
@property (strong, nonatomic) NSMutableArray *attendeesArray;

@end
