//
//  NSManagedObject+Helpers.m
//  IdiotBox
//
//  Created by Robert Edwards on 10/12/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "NSManagedObject+Helpers.h"

@implementation NSManagedObject (Helpers)

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)moc {
    return [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:moc];
}

+ (id)createNewObjectInContext:(NSManagedObjectContext *)moc {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:moc];
}

@end
