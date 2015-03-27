//
//  LoginViewController.m
//  LunchBroke
//
//  Created by Ian Smith on 3/24/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "LoginViewController.h"
#import "signUpViewController.h"
#import "EventTableViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <UIColor+uiGradients.h>

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:signUpViewController]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
    }
    
    
    //Time for some formatting... YEEAAHHHHH
    
    
    //Backround color
    [self.logInView setBackgroundColor:[UIColor clearColor]];
    NSLog(@"Front page code ran");
    
    //Gradient Layer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.logInView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_facebookMessengerStartColor] CGColor], (id)[[UIColor uig_facebookMessengerEndColor]CGColor], nil];
    
    [self.logInView.layer insertSublayer:gradient atIndex:0];
}



@end
