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

- (instancetype) initWithQuery:(NSString *)query;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *query;


-(void)getNearby4SquareLocationsWithCompletionBlock:(void (^)(id ))completionBlock;

@end
