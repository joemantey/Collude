//
//  LocationsTableViewController.h
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *eventsArray;
@property (strong, nonatomic) NSString *selectedObjectID;

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSDate *timeOfEvent;

@end
