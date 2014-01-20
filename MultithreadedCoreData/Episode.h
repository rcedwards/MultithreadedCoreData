//
//  Episode.h
//  IdiotBox
//
//  Created by Robert Edwards on 6/30/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Season, Show;

@interface Episode : PKBaseManagedObject

@property (nonatomic, retain) NSDate * airDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * seriesNumber;
@property (nonatomic, retain) NSNumber * seasonNumber;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDate * reminderDate;
@property (nonatomic, retain) NSString * synopsis;
@property (nonatomic, retain) NSString * thumbURL;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) Season *season;
@property (nonatomic, retain) Show *show;
@property (nonatomic, assign, readonly) BOOL aired;

@end
