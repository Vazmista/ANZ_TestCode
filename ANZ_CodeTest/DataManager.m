//
//  DataManager.m
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import "DataManager.h"
#import "NetworkManager.h"
#import "constants.h"

@interface DataManager()
{

}

@end

static DataManager *_dataManager = nil;

@implementation DataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (DataManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataManager = [[self alloc] init];
    });
    
    return _dataManager;
}

- (id)init
{
    if (self = [super init])
    {
        [self startTimer];
    }
    
    return self;
}

- (void)dealloc
{
    [_earthquakes release];
    _earthquakes = nil;
    
    [_managedObjectContext release];
    _managedObjectContext = nil;
    
    [_persistentStoreCoordinator release];
    _persistentStoreCoordinator = nil;
    
    [_managedObjectContext release];
    _managedObjectContext = nil;
    
    [_dataManager release];
    _dataManager = nil;
    
    [super dealloc];
}

+ (NSManagedObjectContext *)defaultContext
{
   return [[self defaultManager] managedObjectContext];
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "VS.ANZ_CodeTest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ANZ_CodeTest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ANZ_CodeTest.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (NSArray *)earthquakes
{
    if (_earthquakes)
    {
        return _earthquakes;
    }
    
    _earthquakes = [self getAllEntities:@"Earthquake" inContext:[DataManager defaultContext]];
    [_earthquakes retain];
    
    return _earthquakes;
}

#pragma mark - Timer Methods

- (void)startTimer
{
    [self stopTimer];
    _dataRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    [_dataRefreshTimer fire];
}

- (void)stopTimer
{
    if (_dataRefreshTimer)
    {
        [_dataRefreshTimer invalidate];
        _dataRefreshTimer = nil;
    }
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Convenience Methods

- (void)refreshData
{
    if (!self.refreshingData)
    {
        self.refreshingData = YES;
        [[NetworkManager defaultManager] getEarthquakeData:^(NSArray *earthquake, NSError *error)
         {
             self.refreshingData = NO;
             if (earthquake)
             {
                 _earthquakes = earthquake;
                 [_earthquakes retain];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DataRefreshed object:nil];
             }
             else
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DataRefreshFailed object:nil];
             }
             
             if (error)
             {
                 NSLog(@"Error getting eathquake:%@", error.localizedDescription);
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DataRefreshFailed object:nil];
             }
         }];
    }
}

- (NSArray *)getAllEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [fetchRequest release];
    fetchRequest = nil;
    
    return fetchedObjects;
}

NSDateFormatter *TimeDateFormatterForWebservice()
{
    static NSDateFormatter *TimeDateFormatterForWebservice= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        TimeDateFormatterForWebservice = [[NSDateFormatter alloc] init];
        [TimeDateFormatterForWebservice setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
        [TimeDateFormatterForWebservice setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    
    return TimeDateFormatterForWebservice;
}

- (void)addValueFromDictionary:(NSDictionary *)dictionary withValueKey:(NSString *)valueKey saveToKey:(NSString *)key toEntity:(NSManagedObject *)object
{
    if (dictionary[valueKey])
    {
            [object setValue:dictionary[valueKey] forKey:key];
    }
}

- (void)deleteAllEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    [fetchRequest release];
    fetchRequest = nil;
    
    error = nil;
    [context save:&error];
}

@end
