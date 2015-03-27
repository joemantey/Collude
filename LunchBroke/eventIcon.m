//
//  eventIcons.m
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/26/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "EventIcon.h"

@implementation EventIcon

-(instancetype)initWithLabel:(NSString *)iconLabel andImage:(UIImage *)iconImage{
    self = [super init];
    if (self) {
        self.iconLabel = iconLabel;
        self.iconImage = iconImage;
    }
    
    return self;
}

@end
