//
//  IBCoreDataStackCoordinator.m
//  IdiotBox
//
//  Created by Robert Edwards on 10/16/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "PKCoreDataStackCoordinator.h"

static NSString *const kStorePath = @"TVData.sqlite";
static NSString *const kModelName = @"ShowDataModel";
static NSString *const kModelType = @"momd";

@interface PKCoreDataStackCoordinator()

@property (nonatomic, strong) NSManagedObjectContext *primaryPersistingContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation PKCoreDataStackCoordinator

@synthesize mainUIContext = _mainUIContext;

+ (PKCoreDataStackCoordinator *)globalCoordinator {
	static dispatch_once_t onceToken;
	static PKCoreDataStackCoordinator *globalCoordinator;
	dispatch_once(&onceToken, ^{
		globalCoordinator = [[PKCoreDataStackCoordinator alloc] init];
	});
	return globalCoordinator;
}

+ (NSManagedObjectContext *)newBackgroundWorkerContext {
    NSManagedObjectContext *backgroundMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundMOC.parentContext = [PKCoreDataStackCoordinator globalCoordinator].mainUIContext;
    return backgroundMOC;
}

#pragma mark - Private Accessors

- (NSManagedObjectContext *)mainUIContext {
	if (!_mainUIContext) {
		_mainUIContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_mainUIContext.parentContext = self.primaryPersistingContext;
	}
	return _mainUIContext;
}

- (NSManagedObjectContext *)primaryPersistingContext {
	if (!_primaryPersistingContext) {
		_primaryPersistingContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		_primaryPersistingContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
	}
	return _primaryPersistingContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (!_persistentStoreCoordinator) {
		NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @(YES),
								  NSInferMappingModelAutomaticallyOption : @(YES)};
		NSString *storePath = [[self applicationDocumentsDirectory]
							   stringByAppendingPathComponent:kStorePath];
		NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
		NSError *error = nil;
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
									   initWithManagedObjectModel:[self managedObjectModel]];
		if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
													   configuration:nil
																 URL:storeUrl
															 options:options
															   error:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
	if (!_managedObjectModel) {
		NSURL *modelURL = [[NSBundle mainBundle]
						   URLForResource:kModelName withExtension:kModelType];
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	}
    return _managedObjectModel;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
