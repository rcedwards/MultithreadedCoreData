//
//  IBManagedObject.h
//  IdiotBox
//
//  Created by Robert Edwards on 10/11/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PKRemoteDataModelObjectProtocol.h"

@interface PKBaseManagedObject : NSManagedObject

@property (nonatomic, strong) NSData * remoteObject;

- (void)updateLocalObjectWithRemoteObject:(id<PKRemoteDataModelObjectProtocol>)remoteObject;
- (void)setTypeAdjustedValuesForKeysWithDictionary:(NSDictionary *)keyedValues;

+ (NSDictionary *)propertyKeyMappingDictionary;

@end
