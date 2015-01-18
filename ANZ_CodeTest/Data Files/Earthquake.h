//
//  Earthquake.h
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface Earthquake : NSManagedObject

@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * eqID;
@property (nonatomic, retain) NSDate * timedate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * magnitude;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSString * region;

- (NSString *)getDistanceString;

@end
