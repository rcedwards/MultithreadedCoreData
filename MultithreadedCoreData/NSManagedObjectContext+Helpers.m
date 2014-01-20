//
//  NSManagedObjectContext+Helpers.m
//  IdiotBox
//
//  Created by Robert Edwards on 10/24/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "NSManagedObjectContext+Helpers.h"

@implementation NSManagedObjectContext (Helpers)

- (void)saveAndPropagateToStoreWithCompletion:(void(^)(BOOL success, NSError *error))completion {
	NSError *saveError = nil;
	if ([self hasChanges]) {
		if (![self save:&saveError]) {
			PLog(@"Save Error: %@", saveError);
			completion(NO, saveError);
		} else if ([self parentContext]) {
			__block NSManagedObjectContext *parentContext = self.parentContext;
			__block BOOL parentSuccess = YES;
			__block NSError *parentSaveError = nil;
			while (parentContext && (parentSuccess && !parentSaveError)) {
				[parentContext performBlockAndWait:^{
                    NSError *contextSaveError = nil;
					if (![parentContext save:&contextSaveError]) {
						parentSuccess = NO;
						PLog(@"Save Error: %@", contextSaveError);
					} else {
						parentSuccess = YES;
					}
					parentContext = parentContext.parentContext;
                    parentSaveError = contextSaveError;
				}];
			}
			completion(parentSuccess, parentSaveError);
		} else {
			completion(YES, nil);
		}
	} else {
		completion(YES, nil);
	}
}

@end
