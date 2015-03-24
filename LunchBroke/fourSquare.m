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

-(void)findingLocation {
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    
    self.userCoordinate = self.locationManager.location.coordinate;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.lng = [NSString stringWithFormat:@"%f",self.userCoordinate.longitude];
    self.lat = [NSString stringWithFormat:@"%f",self.userCoordinate.latitude];
}

-(void)getNearby4SquareLocations:(void (^)(NSArray *))completionBlock
{
    [self findingLocation];
    NSString *foursquareAPIURLConcatenated = [NSString stringWithFormat:@"%@?ll=%@,%@&client_id=%@&client_secret=%@&v=20150101&m=foursquare", fourSquareAPIURL, self.lat, self.lng, fourSquareClientID, fourSquareClientSecret];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:foursquareAPIURLConcatenated parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}


@end
