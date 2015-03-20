
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

    // Configure the view for the selected state
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    if (isSelected){
        
        self.voteButton.backgroundColor = [UIColor redColor];
    }else{
        self.voteButton.backgroundColor = [UIColor clearColor];
    }
    
}

- (IBAction)voteButtonTapped:(id)sender {
    
    self.isSelected = !self.isSelected;
}
@end
