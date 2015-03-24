//
//  ViewController.m
//  LnchBrkr
//
//  Created by Ian Smith on 3/13/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import "LoginController.h"
#import <Parse/Parse.h>
#import "ParseClient.h"
#import <UIColor+uiGradients.h>


@interface LoginController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginTapped:(id)sender;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _email = self.email;
    _password = self.password;
    [self setColors];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

-(void)setColors
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_namnStartColor] CGColor], (id)[[UIColor uig_sunriseStartColor]CGColor], nil];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginTapped:(id)sender {
    
    self.email = self.emailAddressField.text;
    self.password = self.passwordField.text;
    
    ParseClient *newUser = [[ParseClient alloc] init];
    
    [newUser addNewUserWithEmail:self.email Password:self.password];
}
@end
