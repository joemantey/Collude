//
//  fourSquareVenue.m
//  LunchBroke
//
//  Created by Ian Smith on 3/30/15.
//  Copyright (c) 2015 Joseph Smalls-Mantey. All rights reserved.
//

#import "fourSquareVenue.h"

@implementation fourSquareVenue

- (instancetype)init
{
    return [self initWithlat:@0.0000 lng:@0.0000 address:@"" city:@"" state:@"" postalCode:@"" country:@"" crossStreet:@""];
}

- (instancetype)initWithlat:(NSNumber *)lat
                        lng:(NSNumber *)lng
                    address:(NSString *)address
                       city:(NSString *)city
                      state:(NSString *)state
                 postalCode:(NSString *)postalCode
                    country:(NSString *)country
                crossStreet:(NSString *)crossStreet
{
    self = [super init];
    
    if (self)
    {
        _lat = lat;
        _lng = lng;
        _address = address;
        _city = city;
        _state = state;
        _postalCode = postalCode;
        _country = country;
        _crossStreet = crossStreet;
    }
    
    return self;
}

@end
