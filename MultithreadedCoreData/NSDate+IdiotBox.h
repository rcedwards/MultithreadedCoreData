//
//  NSDate+IdiotBox.h
//  IdiotBox
//
//  Created by Robert Edwards on 10/28/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (IdiotBox)

- (instancetype)dateByReplacingTimeWithTime:(NSString *)time;

@end
