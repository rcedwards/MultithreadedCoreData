//
//  IBTableViewController.h
//  IdiotBox
//
//  Created by Robert Edwards on 10/25/13.
//  Copyright (c) 2013 Panko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKCoreDataStackCoordinator.h"

@interface PKManagedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>  {
    @protected
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
