//
//  ViewController.h
//  LnchBrkr
//
//  Created by Ian Smith on 3/13/15.
//  Copyright (c) 2015 Ian Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>

@interface LoginController : PFLogInViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;

@end


