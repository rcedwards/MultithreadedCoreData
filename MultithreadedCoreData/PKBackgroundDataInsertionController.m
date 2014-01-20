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
#import "Show.h"

@interface PKBackgroundDataInsertionController()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation PKBackgroundDataInsertionController

- (id)init {
	if (self = [super init]) {
		_context = [PKCoreDataStackCoordinator newBackgroundWorkerContext];
	}
	return self;
}

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static PKBackgroundDataInsertionController *sharedInstance = nil;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[[self class] alloc] init];
	});
	return sharedInstance;
}

- (void)beginSampleInsertOrUpdateSync {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
		NSDictionary *homeLandDictionary = @{kShowIDKey: @"247897",
											 kShowNameKey: @"Homeland"};
		PKRemoteShow *homelandShow = [PKRemoteShow deserialize:homeLandDictionary error:nil];
		__unused Show *persistedShow = [Show insertOrUpdateShowWithRemoteShow:homelandShow inMOC:self.context];
		[self.context saveAndPropagateToStoreWithCompletion:^(BOOL success, NSError *error) {}];
	});
}

@end
