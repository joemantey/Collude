
//
//  EventTableViewCell.m
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/19/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "EventTableViewCell.h"

@interface EventTableViewCell ()

@property (nonatomic) BOOL isSelected;

@end
@implementation EventTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setRestorationIdentifier:@"locationCell"];
    // Configure the view for the selected state
}


//method for toggling voting buttons which overrides the setter
-(void)setIsSelected:(BOOL)isSelected{
   
    //override the setter and set it to isSelected
    _isSelected = isSelected;
    
    
    //if the vote button is selected
    if (isSelected){
        
        //...change stuff!
        [self.voteButton setImage:[UIImage imageNamed:@"GreenCheck.png"] forState:UIControlStateNormal];
        self.voteTextField.text = @"";
        
    
    }else{
        [self.voteButton setImage:[UIImage imageNamed:@"mediumbluecheck.png"] forState:UIControlStateNormal];
        self.voteTextField.text = @"";
    }
    
}

- (IBAction)voteButtonTapped:(id)sender {
    
    self.isSelected = !self.isSelected;
}
@end
