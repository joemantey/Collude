//
//  User.m
//  LunchBroke
//
//  Created by Ian Smith on 3/24/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic email;
@dynamic password;
@dynamic username;

+ (NSString *)parseClassName
{
    return @"User";
}

@end
