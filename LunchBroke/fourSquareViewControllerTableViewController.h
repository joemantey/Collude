//
//  fourSquareViewControllerTableViewController.h
//  LunchBroke
//
//  Created by Ian Smith on 3/30/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol fourSquareLocationInfoDelegate <NSObject>

-(void)selectedVeneuWithName:(NSString *)name latitiude:(NSString *)latitude longitude:(NSString *)longitude rating:(NSNumber *)rating;

@end

@interface fourSquareViewControllerTableViewController : UITableViewController

@property (strong, nonatomic) NSString *fourSqQuery;
@property (weak, nonatomic) id<fourSquareLocationInfoDelegate> delegate;

@end
