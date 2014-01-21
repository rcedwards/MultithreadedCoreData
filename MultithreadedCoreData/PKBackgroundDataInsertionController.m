//
//  PKBackgroundDataInsertionController.m
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKBackgroundDataInsertionController.h"

#import "PKCoreDataStackCoordinator.h"
#import "NSManagedObjectContext+Helpers.h"

#import "PKRemoteShow.h"
#import "PKRemoteEpisode.h"

#import "Show.h"
#import "Episode.h"

@interface PKBackgroundDataInsertionController()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation PKBackgroundDataInsertionController

#pragma mark - Lifecycle

- (id)init {
	if (self = [super init]) {
		_context = [PKCoreDataStackCoordinator newBackgroundWorkerContext];
	}
	return self;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
	static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - Public Actions

- (void)beginSampleInsertOrUpdateSync {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
		NSDictionary *homeLandDictionary = @{kShowIDKey: @"247897",
											 kShowNameKey: @"Homeland",
											 kShowEpisodesKey: @[@{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2011-10-02"],
																	 kEpisodeNumberKey : @(1),
																	 kEpisodeRemoteIDKey : @"4079947",
																	 kEpisodeSeasonNumber : @(1),
																	 kEpisodeTitleKey : @"Pilot",
																	 kEpisodeSeasonIDKey : @"570228"
																	 },
																 @{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2011-10-09"],
																	 kEpisodeNumberKey : @(2),
																	 kEpisodeRemoteIDKey : @"4175251",
																	 kEpisodeSeasonNumber : @(1),
																	 kEpisodeTitleKey : @"Grace",
																	 kEpisodeSeasonIDKey : @"570228"
																	 },
																 @{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2011-10-16"],
																	 kEpisodeNumberKey : @(3),
																	 kEpisodeRemoteIDKey : @"4175252",
																	 kEpisodeSeasonNumber : @(1),
																	 kEpisodeTitleKey : @"Clean Skin",
																	 kEpisodeSeasonIDKey : @"570228"
																	 },
																 @{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2012-09-30"],
																	 kEpisodeNumberKey : @(1),
																	 kEpisodeRemoteIDKey : @"4303747",
																	 kEpisodeSeasonNumber : @(2),
																	 kEpisodeTitleKey : @"The Smile",
																	 kEpisodeSeasonIDKey : @"463982"
																	 }]
											 };
        
        NSDictionary *lostDictionary = @{kShowIDKey: @"73739",
                                         kShowNameKey: @"Lost",
                                         kShowEpisodesKey: @[@{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2004-09-22"],
                                                                   kEpisodeSeasonNumber : @(1),
                                                                   kEpisodeSeasonIDKey : @"6345",
                                                                   kEpisodeRemoteIDKey : @"127131",
                                                                   kEpisodeTitleKey : @"Pilot (1)",
                                                                   kEpisodeNumberKey : @(1)
                                                                   },
                                                               @{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2004-09-29"],
                                                                   kEpisodeSeasonNumber : @(1),
                                                                   kEpisodeSeasonIDKey : @"6345",
                                                                   kEpisodeRemoteIDKey : @"127132",
                                                                   kEpisodeTitleKey : @"Pilot (2)",
                                                                   kEpisodeNumberKey : @(2)
                                                                   },
                                                               @{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2004-10-06"],
                                                                   kEpisodeSeasonNumber : @(1),
                                                                   kEpisodeSeasonIDKey : @"6345",
                                                                   kEpisodeRemoteIDKey : @"127133",
                                                                   kEpisodeTitleKey : @"Tabula Rasa",
                                                                   kEpisodeNumberKey : @(3)
                                                                   },
                                                               @{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2005-09-21"],
                                                                   kEpisodeSeasonNumber : @(2),
                                                                   kEpisodeSeasonIDKey : @"6346",
                                                                   kEpisodeRemoteIDKey : @"302656",
                                                                   kEpisodeTitleKey : @"Man of Science, Man of Faith",
                                                                   kEpisodeNumberKey : @(1)
                                                                   },
                                                               @{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2005-09-28"],
                                                                   kEpisodeSeasonNumber : @(2),
                                                                   kEpisodeSeasonIDKey : @"6346",
                                                                   kEpisodeRemoteIDKey : @"302657",
                                                                   kEpisodeTitleKey : @"Adrift",
                                                                   kEpisodeNumberKey : @(2)
                                                                   },
                                                               @{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2006-10-04"],
                                                                   kEpisodeSeasonNumber : @(3),
                                                                   kEpisodeSeasonIDKey : @"16270",
                                                                   kEpisodeRemoteIDKey : @"307435",
                                                                   kEpisodeTitleKey : @"A Tale of Two Cities",
                                                                   kEpisodeNumberKey : @(1)
                                                                   },
                                                               @{
                                                                   kEpisodeAirDateKey : [[self class] dateFromString:@"2006-10-11"],
                                                                   kEpisodeSeasonNumber : @(3),
                                                                   kEpisodeSeasonIDKey : @"16270",
                                                                   kEpisodeRemoteIDKey : @"308048",
                                                                   kEpisodeTitleKey : @"The Glass Ballerina",
                                                                   kEpisodeNumberKey : @(2)
                                                                   }]
											 };
		
        PKRemoteShow *homelandRemoteShow = [PKRemoteShow deserialize:homeLandDictionary error:nil];
		__unused Show *homelandPersistedShow = [Show insertOrUpdateShowWithRemoteShow:homelandRemoteShow inMOC:self.context];
        
        PKRemoteShow *lostRemoteShow = [PKRemoteShow deserialize:lostDictionary error:nil];
        __unused Show *lostPersistedShow = [Show insertOrUpdateShowWithRemoteShow:lostRemoteShow inMOC:self.context];
        
		[self.context saveAndPropagateToStoreWithCompletion:^(BOOL success, NSError *error) {}];
	});
}

#pragma mark - Private Helper

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static PKBackgroundDataInsertionController *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[[self class] alloc] init];
	});
	return sharedInstance;
}

@end
