//
//  Show.m
//  IdiotBox
//
//  Created by Robert Edwards on 6/30/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "Show.h"
#import "Episode.h"
#import "Season.h"

@implementation Show

@dynamic airDay;
@dynamic airTime;
@dynamic airTimeZone;
@dynamic endDate;
@dynamic ended;
@dynamic identifier;
@dynamic name;
@dynamic network;
@dynamic paused;
@dynamic runtime;
@dynamic startDate;
@dynamic posterURL;
@dynamic bannerURL;
@dynamic synopsis;
@dynamic episodes;
@dynamic seasons;
@dynamic localNotificationID;

#pragma mark - Creating Objects

+ (Show *)insertOrUpdateShowWithRemoteShow:(NSObject <PKRemoteDataModelObjectProtocol> *)remoteShow inMOC:(NSManagedObjectContext *)moc {
    __block Show *localShow = nil;
    [moc performBlockAndWait:^{
        localShow = [self showWithIdentifier:[remoteShow remoteIdentifier] inMOC:moc];
        if (!localShow) {
            localShow = (Show *)[Show createNewObjectInContext:moc];
        }
        [localShow updateLocalObjectWithRemoteObject:remoteShow];
    }];
    return localShow;
}

+ (Show *)showWithIdentifier:(NSString *)identifier inMOC:(NSManagedObjectContext *)moc {
    Show *requestedShow = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [Show entityDescriptionInContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(identifier = %@)", identifier];
    [request setPredicate:predicate];
	
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count] > 0) {
            requestedShow = [results objectAtIndex:0];
        }
    }
    return requestedShow;
}

#pragma mark - Fetch Helpers

- (NSUInteger)numberOfEpisodesBehind {
    __block NSUInteger count = 0;
    [self.managedObjectContext performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[Episode entityDescriptionInContext:self.managedObjectContext]];
        request.predicate = [NSPredicate predicateWithFormat:@"show == %@ AND viewed == NO AND airDate < %@", self, [NSDate date]];
        count = [self.managedObjectContext countForFetchRequest:request error:nil];
    }];
    
    return count;
}

- (Episode *)lastViewedEpisode {
    __block Episode *lastEpisode = nil;
    [self.managedObjectContext performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [Episode entityDescriptionInContext:self.managedObjectContext];
        fetchRequest.fetchLimit = 1;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"viewed==YES AND show==%@", self];
        fetchRequest.predicate = predicate;
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airDate" ascending:NO];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        NSError *fetchError = nil;
        NSArray *episodes = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
        if (episodes.count) {
            lastEpisode = [episodes objectAtIndex:0];
        }
        if (fetchError) {
            PLog(@"Error fetching: %@", fetchError);
        }
    }];
    
    return lastEpisode;
}

- (Episode *)nextAiringEpisode
{
    __block Episode *nextEpisode = nil;
    [self.managedObjectContext performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.entity = [Episode entityDescriptionInContext:self.managedObjectContext];
        fetchRequest.fetchLimit = 1;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"airDate>%@ AND show==%@", [NSDate date], self];
        fetchRequest.predicate = predicate;
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"airDate" ascending:YES];
        fetchRequest.sortDescriptors = @[sortDescriptor];
        
        NSError *fetchError = nil;
        NSArray *episodes = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
        if (episodes.count) {
            nextEpisode = [episodes firstObject];
        }
        if (fetchError) {
            PLog(@"Error fetching: %@", fetchError);
        }
    }];

    return nextEpisode;
}

#pragma mark - Base Object Overrides

+ (NSDictionary *)propertyKeyMappingDictionary {
	
	/**
	 Simplified version for example
	 */
	return @{@"showID" : @"identifier",
			 @"name" : @"name"};
	
	/* Full IdiotBox Version
    return @{@"airDay" : @"airDay",
             @"airTime" : @"airTime",
             @"status" : @"ended",
             @"showID" : @"identifier",
             @"name" : @"name",
             @"network" : @"network",
             @"runtime" : @"runtime",
             @"premiereDate" : @"startDate",
             @"posterURL" : @"posterURL",
             @"bannerURL" : @"bannerURL",
             @"overview" : @"synopsis",
             @"episodes" : @"episodes"
             };
	 */
}

- (void)updateLocalObjectWithRemoteObject:(NSObject <PKRemoteDataModelObjectProtocol> *)remoteObject {
    [super updateLocalObjectWithRemoteObject:remoteObject];
}

#pragma mark - KVC

- (void)setValue:(id)value forKey:(NSString *)key {
    PLog(@"%@ :%@", key, value);
    if ([key isEqualToString:@"episodes"]) {
        __block NSMutableArray *staleEpisodes = [[self.episodes allObjects] mutableCopy];
        [value enumerateObjectsUsingBlock:^(NSObject<PKRemoteDataModelObjectProtocol> *remoteEpisode, NSUInteger idx, BOOL *stop) {
            NSPredicate *currentEpisodePredicate = [NSPredicate predicateWithFormat:@"identifier==%@",
                                                    [remoteEpisode remoteIdentifier]];
            NSOrderedSet *matchingEpisodes = [NSOrderedSet orderedSetWithSet:[self.episodes filteredSetUsingPredicate:currentEpisodePredicate]];
            Episode *persistedEpisode = [matchingEpisodes firstObject];
            if (!persistedEpisode) {
                persistedEpisode = (Episode *)[Episode createNewObjectInContext:self.managedObjectContext];
                [self addEpisodesObject:persistedEpisode];
            }
            [persistedEpisode updateLocalObjectWithRemoteObject:remoteEpisode];
            
            [staleEpisodes removeObject:persistedEpisode];
        }];
        
        [staleEpisodes enumerateObjectsUsingBlock:^(Episode *staleEpisode, NSUInteger idx, BOOL *stop) {
            PLog(@"Deleting Episode: %@-%@", staleEpisode.name, staleEpisode.identifier)
            [self.managedObjectContext deleteObject:staleEpisode];
        }];
    } else {
        [super setValue:value forKey:key];
    }
}

@end
