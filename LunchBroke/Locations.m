//
//  Locations.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Locations.h"
#import <Parse/PFObject+Subclass.h>

@implementation Locations

@dynamic name;

+ (NSString *)parseClassName
{
    return @"Locations";
}

@end

