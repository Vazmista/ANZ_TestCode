//
//  LocationManager.m
//  ANZ_CodeTest
//
//  Created by Val on 12/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>

static LocationManager *_sharedManager = nil;

@interface LocationManager()
{
    CLLocationManager *_CLLocationManager;
    CLLocation *_CLLocation;
}

@end

@implementation LocationManager

+ (LocationManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init])
    {
        _CLLocationManager = [self defaultCLLocationManager];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        if ([_CLLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_CLLocationManager requestWhenInUseAuthorization];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [_CLLocationManager release];
    _CLLocationManager = nil;
    
    [_CLLocation release];
    _CLLocation = nil;
    
    [_sharedManager release];
    _sharedManager = nil;
    [super dealloc];
}

-(void)applicationEnterBackground
{
    [self stopUpdatingLocation];
}

-(void)applicationBecameActive
{
    [self startUpdatingLocation];
}

+ (CLLocationManager *)defaultCLLocationManager
{
    return [[self sharedManager] defaultCLLocationManager];
}


- (CLLocationManager *)defaultCLLocationManager
{
    if (!_CLLocationManager) {
        _CLLocationManager = [[CLLocationManager alloc] init];
        _CLLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _CLLocationManager.distanceFilter = kCLDistanceFilterNone;
        _CLLocationManager.delegate = self;
        [self startUpdatingLocation];
    }
    
    return _CLLocationManager;
}

+ (CLLocation *)defaultCLLocation
{
    return [[self sharedManager] defaultCLLocation];
}


- (CLLocation *)defaultCLLocation
{
    if (!_CLLocation)
    {
        _CLLocation = [[CLLocation alloc] init];
    }
    
    return _CLLocation;
}

- (void)startUpdatingLocation
{
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
    else
    {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted)
        {
            NSLog(@"authorizationStatus failed");
        }
        else
        {
            [_CLLocationManager startUpdatingLocation];
        }
    }
}

- (void)stopUpdatingLocation
{
    [_CLLocationManager stopUpdatingLocation];
}

- (void)updateLocation:(CLLocation *)location
{
    if (!_CLLocation)
    {
        _CLLocation = [self defaultCLLocation];
    }
    
    _CLLocation = location;
}

#pragma mark - Location Calls

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for(int i=0;i<locations.count;i++)
    {
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        
        if (!_CLLocation)
        {
            _CLLocation = [self defaultCLLocation];
            _CLLocation = [newLocation retain];
            continue;
        }
        
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        NSTimeInterval saveLocationAge = -[_CLLocation.timestamp timeIntervalSinceNow];
        
        // If the location is more than 30 seconds ago
        if (locationAge > 30.0)
        {
            continue;
        }
        
        // Check if the new location is newer and the old one is older than 10 seconds
        if (saveLocationAge > locationAge && saveLocationAge > 10)
        {
            _CLLocation = [newLocation retain];
            continue;
        }
        
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            
            if (_CLLocation.horizontalAccuracy > newLocation.horizontalAccuracy)
            {
                _CLLocation = [newLocation retain];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // Can't obtain current location
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"Location services have been disabled for this app. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
    NSLog(@"Couldn't obtain location:%@", error);
}


@end
