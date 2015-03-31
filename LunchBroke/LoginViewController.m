//
//  LoginViewController.m
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

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
   }

-(void)viewWillLayoutSubviews
{
    [self.logInView setBackgroundColor:[UIColor clearColor]];
    NSLog(@"View Will Appear layout subiews");
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.logInView.bounds;
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(0, 1);
    gradient.colors = [NSArray arrayWithObjects: (id)[[UIColor uig_facebookMessengerStartColor] CGColor], (id)[[UIColor uig_facebookMessengerEndColor]CGColor], nil];
    
    [self.logInView.layer insertSublayer:gradient atIndex:0];
    

    
}
    
-(void)viewDidLoad{
    [super viewDidLoad];
    self.logInView.dismissButton.hidden = YES;
    [self.logInView setLogo:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"colludeFull"]]];
    //    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nomofomo.png"]]];
    self.logInView.logInButton.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.logInView.logo setFrame:CGRectMake(0, 0, 287.0, 200)];

    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"View did appear");

}

    

@end
