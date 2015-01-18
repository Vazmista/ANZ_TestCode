//
//  LocationManager.h
//  ANZ_CodeTest
//
//  Created by Val on 12/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

/**
 The common shared location manager
 */
+ (LocationManager *)sharedManager;

+ (CLLocation *)defaultCLLocation;

+ (CLLocationManager *)defaultCLLocationManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

/**
 Use to update the location through other means apart from the CLLocationManager, ie. mapView
 @param cannot be nil
 */
- (void)updateLocation:(CLLocation *)location;

@end
