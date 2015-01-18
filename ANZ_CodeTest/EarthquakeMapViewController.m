//
//  EarthquakeMapViewController.m
//  ANZ_CodeTest
//
//  Created by Val on 10/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "EarthquakeMapViewController.h"
#import "LocationManager.h"
#import "DataManager.h"
#import "Earthquake.h"
#import "EarthquakeDetailViewController.h"

static NSString *earthquakePinIdentifier = @"EarthquakePinIdentifier";

@interface EarthquakeMapViewController()
{
    BOOL zoomedToUser;
}

@end

@implementation EarthquakeMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor blueColor];
    
    zoomedToUser = NO;
    [self setupMapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self applyEarthquakes];
}

- (void)dealloc
{
    [_mapView release];
    _mapView = nil;
    
    [super dealloc];
}

#pragma mark - Data Refresh

- (void)removeAllAnnotations
{
    MKUserLocation *userLocation = [self.mapView userLocation];
    NSMutableArray *allAnnotations = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if ( userLocation != nil ) {
        [allAnnotations removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:allAnnotations];
    [allAnnotations release];
    allAnnotations = nil;
}

- (void)applyEarthquakes
{
    //Remove all annotation first
    [self removeAllAnnotations];
    
    NSArray *earthquakesArray = [[DataManager defaultManager].earthquakes copy];

    [self.mapView addAnnotations:earthquakesArray];
    
    [earthquakesArray release];
    earthquakesArray = nil;
}

- (void)DataRefreshed
{
    [self applyEarthquakes];
}

#pragma mark - Map

- (void)setupMapView
{
    if (!self.mapView)
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(-25.400181, 145.023767), 2000000, 2000000);
        
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.topLayoutGuide.length, self.view.bounds.size.width, self.view.bounds.size.height-self.topLayoutGuide.length-self.bottomLayoutGuide.length)];
        self.mapView.delegate = self;
        self.mapView.showsUserLocation = YES;
        self.mapView.mapType = MKMapTypeStandard;
        self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.mapView setTintColor:[UIColor blackColor]];
        
        [self.mapView setRegion:region];
        [self.mapView regionThatFits:region];
        
        [self.view addSubview:self.mapView];
    }
}

#pragma mark - MapView Delegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [[LocationManager sharedManager] updateLocation:userLocation.location];
    
    if (!zoomedToUser)
    {
        MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 100000, 100000);
        
        [mapView setRegion:mapRegion animated:YES];
        [mapView regionThatFits:mapRegion];
        
        zoomedToUser = YES;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *annotationView in views)
    {
        // If we want to center around user
        if(annotationView.annotation == self.mapView.userLocation)
        {
            annotationView.layer.zPosition = FLT_MAX;
            return;
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:earthquakePinIdentifier];
    if (!pinView)
    {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:earthquakePinIdentifier] autorelease];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = NO;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else
    {
        [pinView setAnnotation:annotation];
    }
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // Go to earthquake details screen
    Earthquake *currentEarthquake = view.annotation;
    
    [self.navigationController pushViewController:[[[EarthquakeDetailViewController alloc] initWithEarthquake:currentEarthquake] autorelease] animated:YES];
}


@end
