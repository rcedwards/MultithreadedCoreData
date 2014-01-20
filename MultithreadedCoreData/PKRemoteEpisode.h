//
//  PKRemoteEpisode.h
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kEpisodeAirDateKey;
extern NSString * const kEpisodeRemoteIDKey;
extern NSString * const kEpisodeNumberKey;
extern NSString * const kEpisodeSeasonNumber;
extern NSString * const kEpisodeTitleKey;

@interface PKRemoteEpisode : NSObject <PKRemoteDataModelObjectProtocol>

@property (copy, readonly, nonatomic) NSString *title;
@property (copy, readonly, nonatomic) NSString *episodeID;
@property (strong, readonly, nonatomic) NSDate *airedDate;
@property (strong, readonly, nonatomic) NSNumber *episodeNumber;
@property (strong, readonly, nonatomic) NSNumber *seasonNumber;

@end
