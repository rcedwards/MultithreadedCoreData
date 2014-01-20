//
//  IBCoreDataStackCoordinator.h
//  IdiotBox
//
//  Created by Robert Edwards on 10/16/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKCoreDataStackCoordinator : NSObject

@property (nonatomic, strong) NSManagedObjectContext *mainUIContext;

+ (PKCoreDataStackCoordinator *)globalCoordinator;
+ (NSManagedObjectContext *)newBackgroundWorkerContext;

@end
