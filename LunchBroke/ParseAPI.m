//
//  ParseAPI.m
//  LunchBroke
//
//  Created by Ian Smith on 3/29/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "ParseAPI.h"
#import <Parse.h>
#import "Event.h"

@interface ParseAPI ()

@property (strong, nonatomic) NSString *selectedObjectID;

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *timeOfEvent;
@property (strong, nonatomic) NSArray *attendees;

@end

@implementation ParseAPI

-(void) fetchEvents {
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.eventsArray = [NSMutableArray arrayWithArray:objects];
    }];
}

- (void) fetchEventDataWithID:(NSString *)selectedObjectID {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:selectedObjectID block:^(PFObject *eventData, NSError *error) {
        Event *eventStuff = (Event *)eventData;
        self.eventName = eventStuff.eventName;
        self.timeOfEvent = eventStuff.timeOfEvent;
    }];
}

- (void) fetchEventAttendees {
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:self.selectedObjectID block:^(PFObject *eventData, NSError *error) {
        Event *eventStuff = (Event *)eventData;
        PFQuery *attendeeQuery = [eventStuff.Attendees query];
        [attendeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.attendees = objects;
        }];
    }];
}

@end
