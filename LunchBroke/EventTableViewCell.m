
//
//  EventTableViewCell.m
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Event.h"

@interface EventTableViewCell ()

@property (nonatomic) PFUser *currentUser;
@property (nonatomic) BOOL isSelected;

@end
@implementation EventTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setRestorationIdentifier:@"locationCell"];
    // Configure the view for the selected state
}


//method for toggling voting buttons which overrides the setter
-(void)setIsSelected:(BOOL)isSelected{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];

//    [query whereKey:@"Attendees" equalTo:PFUser.currentUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFRelation *relation = [self.event relationForKey:@"Attendees"];
        if (objects.count > 0) {
            [relation removeObject:PFUser.currentUser];
        } else {
            [relation addObject:PFUser.currentUser];
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
        self.voteTextField.text = @"";
    }
    
}

- (IBAction)voteButtonTapped:(id)sender {
    self.isSelected = !self.isSelected;
}
@end
