//
//  Season.h
//  IdiotBox
//
//  Created by Robert Edwards on 6/30/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode, Show;

@interface Season : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * thumbURL;
@property (nonatomic, retain) NSSet *episodes;
@property (nonatomic, retain) Show *show;

@end

@interface Season (CoreDataGeneratedAccessors)

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)values;
- (void)removeEpisodes:(NSSet *)values;

@end
