//
//  ParseClient.h
//  LnchBrkr
//
//  Created by Ian Smith on 3/13/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseClient : NSObject

-(instancetype) init;

@property (strong, nonatomic) NSString *username;

-(void) pushVoteToParseWithUser;
-(void) getDataFromParse;
-(void) addNewUserWithEmail:(NSString *)email Password:(NSString *)password;

@end
