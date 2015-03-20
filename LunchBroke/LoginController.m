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
    
    ParseClient *newClient = [[ParseClient alloc] init];
    
    [newClient addNewUserWithEmail:self.email Password:self.password];
}
@end
