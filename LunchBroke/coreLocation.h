//
//  coreLocation.h
//  LunchBroke
//
//  Created by Ian Smith on 3/23/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface coreLocation : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
