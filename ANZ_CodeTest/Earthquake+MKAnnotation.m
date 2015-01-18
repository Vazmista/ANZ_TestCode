//
//  Earthquake+MKAnnotation.m
//  ANZ_CodeTest
//
//  Created by Val on 12/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "Earthquake+MKAnnotation.h"

@import ObjectiveC.runtime;

@interface LocationHolder : NSObject
{
@public
    CLLocationCoordinate2D _coordinate;
}
@end

@implementation LocationHolder
@end

@implementation Earthquake (MKAnnotation)

- (LocationHolder *)locationHolder
{
    return objc_getAssociatedObject(self, @selector(locationHolder));
}

- (void)setLocationHolder:(LocationHolder *)holder
{
    objc_setAssociatedObject(self, @selector(locationHolder), holder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)title
{
    return self.region;
}

- (NSString *)subtitle
{
    return [self getDistanceString];
}

- (CLLocationCoordinate2D)coordinate
{
    LocationHolder* holder = [self locationHolder];
    if (!holder)
    {
        holder = [[[LocationHolder alloc] init] autorelease];
        
        holder->_coordinate = CLLocationCoordinate2DIsValid((CLLocationCoordinate2D){self.latitude.doubleValue, self.longitude.doubleValue}) ? (CLLocationCoordinate2D){self.latitude.doubleValue, self.longitude.doubleValue} : (CLLocationCoordinate2D){0.0, 0.0};
        [self setLocationHolder:holder];
    }
    CLLocationCoordinate2D currentCoordinate = holder->_coordinate;
    return currentCoordinate;
}

@end
