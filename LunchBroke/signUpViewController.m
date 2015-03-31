//
//  signUpViewController.m
//  LunchBroke
//
//  Created by Ian Smith on 3/24/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "EventTableViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <UIColor+uiGradients.h>


@implementation SignUpViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.signUpView.dismissButton.hidden = NO;
    [self.signUpView.logo setFrame:CGRectMake(0, 0, 10, 150)];
    [self.signUpView setLogo:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colludeFull"]]];
    
}


-(void)viewDidLayoutSubviews{
    
    NSLog(@"View Will Appear layout subiews xxxxx");
    
    [self.signUpView setBackgroundColor:[UIColor clearColor]];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.signUpView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_mangoPulpEndColor] CGColor], (id)[[UIColor uig_mangoPulpStartColor]CGColor], nil];
    [self.signUpView.logo setFrame:CGRectMake(0, 0, 287.0, 200)];
    [self.signUpView.layer insertSublayer:gradient atIndex:0];
    
//    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nomofomo.png"]]];

    self.signUpView.signUpButton.backgroundColor= [UIColor redColor];
    NSLog(@"View Will Appear layout xxxx");
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"View did appear sign up");
    
    
}


@end
