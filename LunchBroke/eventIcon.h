//
//  eventIcons.h
//  LunchBroke
//
//  Created by Joseph Smalls-Mantey on 3/26/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EventIcon : NSObject

@property (strong, nonatomic) UIImage *iconImage;
@property (strong, nonatomic) NSString *iconLabel;

-(instancetype)initWithLabel:(NSString *)iconLabel andImage:(UIImage *)iconImage;

@end
