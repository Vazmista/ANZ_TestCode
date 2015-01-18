//
//  NetworkManager.h
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)defaultManager;

/**
 Requests the latest set of earthquakes and saves them to core data.
 @param completion A block that's called on the main thread upon completion.
 */
- (void)getEarthquakeData:(void(^)(NSArray *earthquakes, NSError *error))completion;


@end
