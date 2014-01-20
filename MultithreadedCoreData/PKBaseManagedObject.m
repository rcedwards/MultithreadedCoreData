//
//  IBManagedObject.m
//  IdiotBox
//
//  Created by Robert Edwards on 10/11/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "PKBaseManagedObject.h"
#import "PKRemoteDataModelObjectProtocol.h"

@implementation PKBaseManagedObject

@dynamic remoteObject;

#pragma mark - Class Methods

+ (NSDictionary *)propertyKeyMappingDictionary {
    mustOverride();
}

#pragma mark - Instance Helpers

- (void)updateLocalObjectWithRemoteObject:(NSObject<PKRemoteDataModelObjectProtocol> *)remoteObject {
    NSArray *propertyKeys = [[[self class] propertyKeyMappingDictionary] allKeys];
    NSDictionary *updateDictionary = [remoteObject dictionaryWithValuesForKeys:propertyKeys];
	[self setValuesForKeysWithDictionary:updateDictionary];
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues {
    __block NSMutableDictionary *mappedDictionary = [NSMutableDictionary dictionaryWithCapacity:keyedValues.count];
    [keyedValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		PLog(@"%@",key);
        BOOL nonEmptyValue = ![obj isEqual:[NSNull null]];
		if (nonEmptyValue) {
			NSString *mappedKey = [[self class] propertyKeyMappingDictionary][key];
			if (mappedKey) {
				/** These are properties of this class and will be set using the adjustedValues method */
				mappedDictionary[mappedKey] = obj;
			}
		}
    }];
	[self setTypeAdjustedValuesForKeysWithDictionary:mappedDictionary];
}

- (void)setTypeAdjustedValuesForKeysWithDictionary:(NSDictionary *)keyedValues {
    [self.entity.propertiesByName enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id mappedKeyValue = [keyedValues objectForKey:key];
        if (mappedKeyValue) {
            if ([obj isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeType type = [obj attributeType];
				if (type == NSStringAttributeType && [mappedKeyValue isKindOfClass:[NSURL class]]) {
					mappedKeyValue = [mappedKeyValue absoluteString];
				} else if (((type == NSInteger16AttributeType) ||
							(type == NSInteger32AttributeType) ||
							(type == NSInteger64AttributeType) ||
							(type == NSBooleanAttributeType)) &&
						   ([mappedKeyValue isKindOfClass:[NSString class]])) {
					mappedKeyValue = @([mappedKeyValue integerValue]);
				}
				[self setValue:mappedKeyValue forKey:key];
			} else if ([obj isKindOfClass:[NSRelationshipDescription class]]) {
                [self setValue:mappedKeyValue forKey:key];
            }
        }
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    PLog(@"%@:%@", key, value);
}

- (id)valueForUndefinedKey:(NSString *)key {
    PLog(@"%@", key);
    return nil;
}

@end
