//
//  User.m
//  LunchBroke
//
//  Created by Ian Smith on 3/26/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username;
@dynamic email;

+ (NSString *)parseClassName
{
    return @"User";
}

@end
