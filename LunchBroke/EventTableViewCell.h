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
- (void)updateUI;



@property (nonatomic) Event *event;


@end
