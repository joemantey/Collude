//
//  AddLocationViewController.h
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *selectedObjectID;
@property (strong, nonatomic) Event *selectedEvent;
@property (strong, nonatomic) Event *event;

@end
