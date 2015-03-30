
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
- (IBAction)voteButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *voteTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextField *eventAttendeeCount;
@property (weak, nonatomic) IBOutlet UITextField *eventDate;
@property (weak, nonatomic) IBOutlet UIImageView *eventIcon;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;


@property (nonatomic) BOOL isSelected;



@end

@implementation EventTableViewCell

+ (UITableViewCell) updateUI {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    
    Event *currentEvent = self.eventsArray[indexPath.row];
    
    //get the name
    if (currentEvent.eventName) {
        cell.eventName.text = currentEvent.eventName;
    }
    NSLog(@"Tableview Delegate ran");
    //get the date
    if (currentEvent.timeOfEvent) {
        NSDate *curentEventDate = currentEvent.timeOfEvent;
        NSString *dateString = [NSDateFormatter localizedStringFromDate:curentEventDate
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        cell.eventDate.text = [NSString stringWithFormat:@"%@", dateString];
    }
    
    //get the images
    if (currentEvent.imageLabel) {
        cell.eventIcon.image =  [UIImage imageNamed:currentEvent.imageLabel];
    }
    
    //add line for the bottom of the tableview cell
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 2)];
    
    lineView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineView];
    return cell;
}

- (void)setEvent:(Event *)event
{
    _event = event;
    
    //[self updateUI];
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
        self.voteTextField.text = @"rsvp";
    }
    
}

- (IBAction)voteButtonTapped:(id)sender {
    self.isSelected = !self.isSelected;
}
@end
