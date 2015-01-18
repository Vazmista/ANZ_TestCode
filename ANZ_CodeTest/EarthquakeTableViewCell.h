//
//  EarthquakeTableViewCell.h
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+Convenience.h"

@class Earthquake;
@interface EarthquakeTableViewCell : UITableViewCell

- (void)parseEarthquake:(Earthquake *)earthquake;

@end
