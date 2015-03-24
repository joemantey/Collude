//
//  EventTableViewCell.h
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;
@interface EventTableViewCell : UITableViewCell

- (IBAction)voteButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *voteTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextField *eventAttendeeCount;
@property (weak, nonatomic) IBOutlet UITextField *eventDate;
@property (weak, nonatomic) IBOutlet UIImageView *eventIcon;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;

@property (nonatomic) Event *event;


@end
