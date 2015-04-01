//
//  LocationsTableViewController.h
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "Event.h"

@interface EventTableViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

//event objects are written to this array and use in the tableview methods
@property (strong, nonatomic) NSMutableArray *eventsArray;

//the id -used and issued by parse- for the selcted event
@property (strong, nonatomic) NSString *selectedEventObjectID;


//properties used by fetch methods within tablview
@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *timeOfEvent;

-(void) fetchEvents;

@end
