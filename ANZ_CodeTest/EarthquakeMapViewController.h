//
//  EarthquakeMapViewController.h
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "constants.h"

@interface EarthquakeMapViewController : UIViewController <DataRefreshed, MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end
