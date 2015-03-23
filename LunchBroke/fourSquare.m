//
//  coreLocation.m
//  LunchBroke
//
//  Created by Ian Smith on 3/23/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "fourSquare.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

@implementation fourSquare

NSString *const fourSquareClientID = @"YQ5S1FET0XHJY3FGVJ1XY25NXTXU4OLN2XVFP5IV1TWK4EXA";
NSString *const fourSquareClientSecret = @"DAEBFC0VKT333HMWN4HO30Q5PAWBSIE5WCHJT125U0DQOMZP";

- (instancetype) init {
    self = [super init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    return self;
}


- (void) getFourSquareNearbyLocations {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
