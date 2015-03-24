//
//  fourSquare.m
//  LunchBroke
//
//  Created by Ian Smith on 3/23/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "fourSquare.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@implementation fourSquare

NSString *const fourSquareClientID = @"YQ5S1FET0XHJY3FGVJ1XY25NXTXU4OLN2XVFP5IV1TWK4EXA";
NSString *const fourSquareClientSecret = @"DAEBFC0VKT333HMWN4HO30Q5PAWBSIE5WCHJT125U0DQOMZP";
NSString *const fourSquareAPIURL = @"https://api.foursquare.com/v2/venues/explore";
NSString *const fourSquareV = @"20150101";

- (instancetype)init {
    if (self = [super init])
    {
        // Do something...
    }
    return self;
}

- (void) locationConfigAndInit {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    NSLog(@"Current Location: %@", self.currentLocation);
}

- (void)getFourSquareNearbyLocations {
    
    
    
//    NSString *fourSquareURL = [NSString stringWithFormat:@"%@?ll=%@client_id=%@&client_secret=%@", fourSquareAPIURL, ll, fourSquareClientID, fourSquareClientSecret];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.foursquare.com/v2/venues/explore" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
