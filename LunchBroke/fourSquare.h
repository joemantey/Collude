//
//  fourSquare.h
//  LunchBroke
//
//  Created by Ian Smith on 3/23/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface fourSquare : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
//@property (strong, nonatomic) NSArray *currentLocation;

-(void)locationConfigAndInit;


@end
