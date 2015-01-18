//
//  DataManager.h
//  ANZ_CodeTest
//
//  Created by Val on 9/01/2015.
//  Copyright (c) 2015 Valery Shorinov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSTimer *dataRefreshTimer;
@property (nonatomic, strong) NSArray *earthquakes;
@property (nonatomic) BOOL refreshingData;

+ (DataManager *)defaultManager;
+ (NSManagedObjectContext *)defaultContext;

/**
 Date formatter for converting timeDate(NSString) from the web service
 */
NSDateFormatter *TimeDateFormatterForWebservice();

/**
 Saves data to persistant store
 */
- (void)saveContext;

/**
 Forces a refresh of data and pushes a notification once complete
 */
- (void)refreshData;

/**
 Deletes all entities of a certain name
 @param entityName Name of entity to delete
 @param context ManagedObjectContext to retrieve from
 */
- (void)deleteAllEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context;

/**
 Get all entities of a certain name
 @param entityName Name of entities to retrieve
 @param context ManagedObjectContext to retrieve from
 */
- (NSArray *)getAllEntities:(NSString *)entityName inContext:(NSManagedObjectContext *)context;

/**
 Convenience method to add value to an object from a dictionary. Check to make sure that 
 @param completion A block that's called on the main thread upon completion.
 */
- (void)addValueFromDictionary:(NSDictionary *)dictionary withValueKey:(NSString *)valueKey saveToKey:(NSString *)key toEntity:(NSManagedObject *)object;

@end
