//
//  PKEpisodesViewController.h
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKManagedTableViewController.h"

@class Show;

@interface PKEpisodesViewController : PKManagedTableViewController

- (id)initWithShow:(Show *)show;

@end
