
//
//  EventTableViewCell.m
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Event.h"
#import <Parse/Parse.h>
#import "EventTableViewController.h"

@interface EventTableViewCell ()

@property (nonatomic) PFUser *currentUser;
@property (nonatomic) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UITextField *voteTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextField *eventAttendeeCount;
@property (weak, nonatomic) IBOutlet UITextField *eventDate;
@property (weak, nonatomic) IBOutlet UIImageView *eventIcon;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (strong, nonatomic) NSString *eventObjectId;
@property (strong, nonatomic) NSArray *eventAttendeesArray;

@end

@implementation EventTableViewCell

- (void)updateUI{
    if (self.event.eventName) {
        self.eventName.text = self.event.eventName;
    }
    
    if (self.event.timeOfEvent) {
        //create a string from the event property's time
        NSDate *curentEventDate = self.event.timeOfEvent;
        
        //create a date string using the nsdate formatter using the event property's time
        NSString *dateString = [NSDateFormatter localizedStringFromDate:curentEventDate
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        
        //set the the display text to the date string from the date picker
        self.eventDate.text = [NSString stringWithFormat:@"%@", dateString];
    }
    
    if (self.event.imageLabel) {
        self.eventIcon.image = [UIImage imageNamed:self.event.imageLabel];
    }
    
  [self fetchEventAttendees];
    self.eventAttendeeCount.text = [NSString stringWithFormat:@"Attendees: %lu", (unsigned long)[self.eventAttendeesArray count]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setRestorationIdentifier:@"locationCell"];
    
    // Configure the view for the selected state
}


//method for toggling voting buttons which overrides the setter
-(void)setIsSelected:(BOOL)isSelected{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFRelation *relation = [self.event relationForKey:@"Attendees"];
        if (_isSelected) {
            [relation addObject:PFUser.currentUser];
        } else {
            [relation removeObject:PFUser.currentUser];
        }
        [self.event saveInBackground];
    }];
    
    //override the setter and set it to isSelected
    _isSelected = isSelected;
    
    //if the vote button is selected
    if (isSelected){
        
        //...change stuff!
        [self.voteButton setImage:[UIImage imageNamed:@"GreenCheck.png"] forState:UIControlStateNormal];
        self.voteTextField.text = @"";
        
        
    }else{
        [self.voteButton setImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
        self.voteTextField.text = @"rsvp";
    }
    
}

- (IBAction)voteButtonTapped:(id)sender {
    self.isSelected = !self.isSelected;
}

- (void) fetchEventAttendees{
    self.eventObjectId = [self.event objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query getObjectInBackgroundWithId:self.eventObjectId block:^(PFObject *eventData, NSError *error) {
        Event *eventStuff = (Event *)eventData;
        
        PFQuery *attendeeQuery = [eventStuff.Attendees query];
        
//        [attendeeQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//            NSLog(@"%d",number);
//        }];
        
        [attendeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.eventAttendeesArray =[NSMutableArray arrayWithArray:objects];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil userInfo:nil];
//            [self updateUI];
        }];
    }];
}
@end
