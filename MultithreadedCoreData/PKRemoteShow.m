//
//  PKRemoteShow.m
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKRemoteShow.h"

NSString * const kShowIDKey = @"showID";
NSString * const kShowNameKey = @"name";
NSString * const kShowEpisodesKey = @"episodes";

@interface PKRemoteShow()

@property (copy, nonatomic) NSString *showID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *episodes;

@end

@implementation PKRemoteShow

#pragma mark - Remote Object Protocol Implementation

- (NSString *)remoteIdentifier {
	return self.showID;
}

- (NSDictionary *)serialize {
	return @{kShowIDKey: self.showID,
			 kShowNameKey: self.name,
			 kShowEpisodesKey: self.episodes};
}

+ (id<PKRemoteDataModelObjectProtocol>)deserialize:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error {
	PKRemoteShow *remoteShow = [[PKRemoteShow alloc] init];
	remoteShow.showID = dictionary[kShowIDKey];
	remoteShow.name = dictionary[kShowNameKey];
	remoteShow.episodes = dictionary[kShowEpisodesKey];
	return remoteShow;
}

@end
