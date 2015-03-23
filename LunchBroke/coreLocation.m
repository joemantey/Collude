//
//  coreLocation.m
//  LunchBroke
//
//  Created by Ian Smith on 3/23/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "coreLocation.h"
#import <CoreLocation/CoreLocation.h>

@implementation coreLocation

- (instancetype) init {
    self = [super init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    return self;
}

- locationManager {
    return self.locationManager = [[CLLocationManager alloc] init];
}



@end
