//
//  Show.h
//  IdiotBox
//
//  Created by Robert Edwards on 6/30/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode, Season, LRTVDBShow;

@interface Show : PKBaseManagedObject

@property (nonatomic, retain) NSString * airDay;
@property (nonatomic, retain) NSString * airTime;
@property (nonatomic, retain) NSString * airTimeZone;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * ended;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * network;
@property (nonatomic, retain) NSNumber * paused;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * posterURL;
@property (nonatomic, retain) NSString * bannerURL;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSSet *episodes;
@property (nonatomic, retain) NSSet *seasons;
@property (nonatomic, retain) NSString *localNotificationID;

- (NSUInteger)numberOfEpisodesBehind;
- (Episode *)nextAiringEpisode;
- (Episode *)lastViewedEpisode;
+ (Show *)insertOrUpdateShowWithRemoteShow:(NSObject <PKRemoteDataModelObjectProtocol> *)remoteShow
									 inMOC:(NSManagedObjectContext *)moc;

@end

@interface Show (CoreDataGeneratedAccessors)

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)values;
- (void)removeEpisodes:(NSSet *)values;

- (void)addSeasonsObject:(Season *)value;
- (void)removeSeasonsObject:(Season *)value;
- (void)addSeasons:(NSSet *)values;
- (void)removeSeasons:(NSSet *)values;

@end
