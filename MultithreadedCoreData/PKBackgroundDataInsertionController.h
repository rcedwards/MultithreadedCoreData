//
//  PKBackgroundDataInsertionController.h
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKBackgroundDataInsertionController : NSObject

+ (instancetype)sharedInstance;
- (void)beginSampleInsertOrUpdateSync;

@end
