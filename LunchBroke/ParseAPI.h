//
//  ParseAPI.h
//  LunchBroke
//
//  Created by Ian Smith on 3/29/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseAPI : NSObject

-(void) fetchEvents;

@property (strong, nonatomic) NSMutableArray *eventsArray;

@end
