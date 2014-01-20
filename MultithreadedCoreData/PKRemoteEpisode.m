//
//  PKRemoteEpisode.m
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKRemoteEpisode.h"

NSString * const kEpisodeAirDateKey = @"airedDate";
NSString * const kEpisodeRemoteIDKey = @"episodeID";
NSString * const kEpisodeNumberKey = @"episodeNumber";
NSString * const kEpisodeSeasonNumber = @"seasonNumber";
NSString * const kEpisodeTitleKey = @"title";
NSString * const kEpisodeSeasonIDKey = @"seasonID";

@interface PKRemoteEpisode()

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *episodeID;
@property (strong, nonatomic) NSDate *airedDate;
@property (strong, nonatomic) NSNumber *episodeNumber;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (copy, nonatomic) NSString *seasonID;

@end

@implementation PKRemoteEpisode

#pragma mark - Remote Object Protocol Implementation

- (NSString *)remoteIdentifier {
	return self.episodeID;
}

- (NSDictionary *)serialize {
	return @{kEpisodeAirDateKey: self.airedDate,
			 kEpisodeNumberKey: self.episodeNumber,
			 kEpisodeRemoteIDKey: self.episodeID,
			 kEpisodeSeasonNumber: self.seasonNumber,
			 kEpisodeTitleKey: self.title,
			 kEpisodeSeasonIDKey: self.seasonID};
}

+ (id<PKRemoteDataModelObjectProtocol>)deserialize:(NSDictionary *)dictionary error:(NSError *__autoreleasing *)error {
	PKRemoteEpisode *remoteEpisode = [[PKRemoteEpisode alloc] init];
	remoteEpisode.title = dictionary[kEpisodeTitleKey];
	remoteEpisode.episodeID = dictionary[kEpisodeRemoteIDKey];
	remoteEpisode.airedDate = dictionary[kEpisodeAirDateKey];
	remoteEpisode.episodeNumber = dictionary[kEpisodeNumberKey];
	remoteEpisode.seasonNumber = dictionary[kEpisodeSeasonNumber];
	remoteEpisode.seasonID = dictionary[kEpisodeSeasonIDKey];
	return remoteEpisode;
}

@end
