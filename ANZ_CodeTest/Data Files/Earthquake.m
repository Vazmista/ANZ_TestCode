//
//  Earthquake.m
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "Earthquake.h"
#import "LocationManager.h"

@implementation Earthquake

@dynamic source;
@dynamic eqID;
@dynamic timedate;
@dynamic latitude;
@dynamic longitude;
@dynamic magnitude;
@dynamic depth;
@dynamic region;

- (NSString *)getDistanceString
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    if (CLLocationCoordinate2DIsValid(coordinate))
    {
        MKMapPoint mapPoint1 = MKMapPointForCoordinate(coordinate);
        MKMapPoint mapPoint2 = MKMapPointForCoordinate([LocationManager defaultCLLocation].coordinate);
        
        CLLocationDistance distance = MKMetersBetweenMapPoints(mapPoint1, mapPoint2);
        
        return [NSString stringWithFormat:@"%.2lfkm away", distance/1000];
    }
    else
    {
        return @"Invalid Coordinate";
    }
}

@end
