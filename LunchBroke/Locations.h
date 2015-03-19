//
//  Locations.h
//  LnchBrkr
//
//  Created by Ian Smith on 3/16/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Locations : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *name;

@end
