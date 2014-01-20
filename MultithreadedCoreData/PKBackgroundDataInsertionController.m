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
																	 kEpisodeTitleKey : @"Pilot"
																	 },
																 @{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2011-10-09"],
																	 kEpisodeNumberKey : @(2),
																	 kEpisodeRemoteIDKey : @"4175251",
																	 kEpisodeSeasonNumber : @(1),
																	 kEpisodeTitleKey : @"Grace"
																	 },
																 @{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2011-10-16"],
																	 kEpisodeNumberKey : @(3),
																	 kEpisodeRemoteIDKey : @"4175252",
																	 kEpisodeSeasonNumber : @(1),
																	 kEpisodeTitleKey : @"Clean Skin"
																	 },
																 @{
																	 kEpisodeAirDateKey : [[self class] dateFromString:@"2012-09-30"],
																	 kEpisodeNumberKey : @(1),
																	 kEpisodeRemoteIDKey : @"4303747",
																	 kEpisodeSeasonNumber : @(2),
																	 kEpisodeTitleKey : @"The Smile"
																	 }]
											 };
		PKRemoteShow *homelandShow = [PKRemoteShow deserialize:homeLandDictionary error:nil];
		__unused Show *persistedShow = [Show insertOrUpdateShowWithRemoteShow:homelandShow inMOC:self.context];
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
