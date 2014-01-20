//
//  NSDate+IdiotBox.m
//  IdiotBox
//
//  Created by Robert Edwards on 10/28/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import "NSDate+IdiotBox.h"

@implementation NSDate (IdiotBox)

- (instancetype)dateByReplacingTimeWithTime:(NSString *)time {
    
    static NSCalendar *calendar = nil;
    static NSDateFormatter *timeFormatter = nil;
    static NSCalendarUnit dateFlags = 0;
    static NSCalendarUnit timeFlags = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
        dateFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        
        timeFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
        timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm a";
    });
    
    
    NSDate *timeDate = [timeFormatter dateFromString:time];
    
    NSDateComponents *dateComponents = [calendar components:dateFlags fromDate:self];
    NSDateComponents *timeComponents = [calendar components:timeFlags fromDate:timeDate];

    NSDate *finalDate = [calendar dateFromComponents:dateComponents];
    finalDate = [calendar dateByAddingComponents:timeComponents toDate:finalDate options:0];
    
    return finalDate;
}

@end
