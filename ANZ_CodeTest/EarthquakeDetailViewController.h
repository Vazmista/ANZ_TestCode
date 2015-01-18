//
//  EarthquakeDetailViewController.h
//  ANZ_CodeTest
//
//  Created by Val on 14/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Earthquake;
@interface EarthquakeDetailViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) Earthquake *earthquake;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UIView *detailView;

- (id)initWithEarthquake:(Earthquake *)earthquake;

@end
