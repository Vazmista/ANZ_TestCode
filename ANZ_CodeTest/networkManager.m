//
//  NetworkManager.m
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "NetworkManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataManager.h"
#import "constants.h"

static NetworkManager *_networkManager = nil;
static NSString *const NetworkManagerBaseURL = @"http://www.seismi.org/api/";

@interface NetworkManager() {
    
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic, strong) NSString *baseURL;

@end

@implementation NetworkManager

+ (NetworkManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [[self alloc] init];
    });
    
    return _networkManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.baseURL = NetworkManagerBaseURL;
    }
    
    return self;
}

- (void)dealloc
{
    [_httpClient release];
    _httpClient = nil;
    
    [_networkManager release];
    _networkManager = nil;
    
    [super dealloc];
}

- (AFHTTPRequestOperationManager *)httpClient
{
    if (!_httpClient) {
        if (self.baseURL)
        {
            _httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseURL]];
        }
        else
        {
            _httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:NetworkManagerBaseURL]];
        }
        _httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",nil];
    }
    
    return _httpClient;
}

- (void)getEarthquakeData:(void(^)(NSArray *earthquakes, NSError *error))completion
{
    
    [self.httpClient GET:@"eqs" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         NSLog(@"ResponseObject:%@", responseObject);
         
         // Never used
//         NSNumber *count = responseObject[@"count"];
         
         NSArray *earthquakeArray = responseObject[@"earthquakes"];
         
         if (earthquakeArray.count) // If there are new earthquakes clear the database.
         {
             [[DataManager defaultManager] deleteAllEntities:@"Earthquake" inContext:[DataManager defaultContext]];
         }
         else
         {
             completion(nil, nil);
         }
         
         NSDateFormatter *dateFormatter = TimeDateFormatterForWebservice();
         
         for (NSDictionary *earthquake in earthquakeArray)
         {
             NSLog(@"EarthQuake:%@", earthquake);
             
             NSManagedObject *newEarthquake = [NSEntityDescription insertNewObjectForEntityForName:@"Earthquake" inManagedObjectContext:[DataManager defaultContext]];
             
             [[DataManager defaultManager] addValueFromDictionary:earthquake withValueKey:@"src" saveToKey:@"source" toEntity:newEarthquake];
             [[DataManager defaultManager] addValueFromDictionary:earthquake withValueKey:@"eqid" saveToKey:@"eqID" toEntity:newEarthquake];
             [[DataManager defaultManager] addValueFromDictionary:earthquake withValueKey:@"region" saveToKey:@"region" toEntity:newEarthquake];
             if (earthquake[@"lat"])
             {
                 [newEarthquake setValue:[NSNumber numberWithDouble:[earthquake[@"lat"] doubleValue]] forKey:@"latitude"];
             }
             if (earthquake[@"lon"])
             {
                 [newEarthquake setValue:[NSNumber numberWithDouble:[earthquake[@"lon"] doubleValue]] forKey:@"longitude"];
             }
             if (earthquake[@"magnitude"])
             {
                 [newEarthquake setValue:[NSNumber numberWithFloat:[earthquake[@"magnitude"] floatValue]] forKey:@"magnitude"];
             }
             if (earthquake[@"depth"])
             {
                 [newEarthquake setValue:[NSNumber numberWithFloat:[earthquake[@"depth"] floatValue]] forKey:@"depth"];
             }
             
             if (earthquake[@"timedate"])
             {
                 NSDate *date = [dateFormatter dateFromString:earthquake[@"timedate"]];
                 [newEarthquake setValue:date forKey:@"timedate"];
             }
             

             DLog(@"Object earthquake:%@", newEarthquake);
         }
         
         NSError *error = nil;
         if (![[DataManager defaultContext] save:&error]) {
             NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
         }
         
         completion([[DataManager defaultManager] getAllEntities:@"Earthquake" inContext:[DataManager defaultContext]], error);
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         DLog(@"Operation:%@", operation);
         
         completion(nil, error);
     }];
}


@end