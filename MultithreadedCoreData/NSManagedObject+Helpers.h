//
//  NSManagedObject+Helpers.h
//  IdiotBox
//
//  Created by Robert Edwards on 10/12/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helpers)

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)moc;
+ (id)createNewObjectInContext:(NSManagedObjectContext *)moc;

@end
