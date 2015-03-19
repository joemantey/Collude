//
//  ParseClient.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/13/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "ParseClient.h"
#import <Parse/Parse.h>

@implementation ParseClient

-(instancetype) init
{
    self = [super init];
    
    if (self) {
        // do stuffffsss (like a bawse)
    }
    return self;
}

-(void) pushVoteToParseWithUser:(PFObject *)currentUser andEvent:(PFObject *)event
{
//    //Pushing data up to Parse
//    NSMutableArray *
//    
//    PFObject *voteObject = [PFObject objectWithClassName:@"Vote"];
//    
//    
//    
//    [voteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // Some stuff should happen here.
//        } else {
//            NSLog(@"%@",error.description);
//        }
//    }];
}

-(void) getDataFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    [query getObjectInBackgroundWithId:@"2b0QMLJHrv" block:^(PFObject *testObject, NSError *error) {
        if (!error) {
            // Retrive values like below,object id is retrieved by objects.objectId
            NSString *firstName = testObject[@"firstName"];
            NSString *lastName = testObject[@"lastName"];
            NSLog(@"First Name: %@", firstName);
            NSLog(@"Last Name: %@", lastName);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void) addNewUserWithEmail:(NSString *)email Password:(NSString *)password
{
    PFUser *user = [PFUser user];
    user.username = email;
    user.email = email;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
    }];
}

@end
