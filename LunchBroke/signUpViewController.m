//
//  signUpViewController.m
//  LunchBroke
//
//  Created by Ian Smith on 3/24/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "signUpViewController.h"
#import <Parse/Parse.h>

@implementation signUpViewController

// Sent to the PFSignUpViewControllere whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

@end
