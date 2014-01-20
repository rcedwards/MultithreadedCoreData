//
//  NSManagedObjectContext+Helpers.h
//  IdiotBox
//
//  Created by Robert Edwards on 10/24/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Helpers)

- (void)saveAndPropagateToStoreWithCompletion:(void(^)(BOOL success, NSError *error))completion;

@end
