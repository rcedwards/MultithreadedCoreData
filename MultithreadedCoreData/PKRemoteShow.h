//
//  PKRemoteShow.h
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kShowIDKey;
extern NSString * const kShowNameKey;
extern NSString * const kShowEpisodesKey;

@interface PKRemoteShow : NSObject <PKRemoteDataModelObjectProtocol>

@property (copy, readonly, nonatomic) NSString *showID;
@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSArray *episodes;

@end
