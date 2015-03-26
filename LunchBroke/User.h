//
//  User.h
//  LunchBroke
//
//  Created by Ian Smith on 3/26/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface User : PFUser <PFSubclassing>

@property  (strong, nonatomic) NSString *email;
@property  (strong, nonatomic) NSString *username;

@end
