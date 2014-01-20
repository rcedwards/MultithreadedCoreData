//
//  Episode.m
//  IdiotBox
//
//  Created by Robert Edwards on 6/30/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "Episode.h"
#import "Season.h"
#import "Show.h"
#import "NSDate+IdiotBox.h"

@implementation Episode

@dynamic airDate;
@dynamic name;
@dynamic seriesNumber;
@dynamic seasonNumber;
@dynamic rating;
@dynamic reminderDate;
@dynamic synopsis;
@dynamic thumbURL;
@dynamic viewed;
@dynamic season;
@dynamic show;
@dynamic identifier;

+ (NSDictionary *)propertyKeyMappingDictionary {
	/* Smaller Sample Version */
	return @{@"title": @"name",
			 @"episodeID" : @"identifier",
			 @"airedDate" : @"airDate",
			 @"episodeNumber" : @"seasonNumber"};
	
	/* Full IdiotBox version
    return @{@"title" : @"name",
             @"episodeID" : @"identifier",
             @"airedDate" : @"airDate",
             @"episodeNumber" : @"seasonNumber",
             @"rating" : @"rating",
             @"overview" : @"synopsis",
             @"imageURL" : @"thumbURL",
             @"rating" : @"rating"};
	 */
}

-(void)updateLocalObjectWithRemoteObject:(NSObject <PKRemoteDataModelObjectProtocol> *)remoteObject {
	/** Have to handle Season obj here since we need two attributes */
    Season *persistedSeason = nil;
    NSPredicate *currentSeasonPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",
                                           [remoteObject remoteIdentifier]];
    NSOrderedSet *matchingSeasons = [NSOrderedSet orderedSetWithSet:[self.show.seasons filteredSetUsingPredicate:currentSeasonPredicate]];
    if ([matchingSeasons count] > 0) {
        persistedSeason = matchingSeasons[0];
    }
    if (!persistedSeason) {
        persistedSeason = (Season *)[Season createNewObjectInContext:self.managedObjectContext];
		persistedSeason.identifier = [remoteObject valueForKey:@"seasonID"];
		persistedSeason.number = [[remoteObject valueForKey:@"seasonNumber"] stringValue];
		
        [self.show addSeasonsObject:persistedSeason];
    }
    [persistedSeason addEpisodesObject:self];
    
    [super updateLocalObjectWithRemoteObject:remoteObject];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:NSStringFromSelector(@selector(airDate))]) {
        //Manipulate date to include time.
        value = [value dateByReplacingTimeWithTime:self.show.airTime];
        [super setValue:value forKey:key];
    } else {
        [super setValue:value forKey:key];
    }
}

- (BOOL)aired {
    BOOL aired = NO;
    NSComparisonResult result = [self.airDate compare:[NSDate date]];
    if (result == NSOrderedAscending) {
        aired = YES;
    }
    return aired;
}

@end
