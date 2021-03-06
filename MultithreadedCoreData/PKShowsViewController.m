//
//  PKShowsViewController.m
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKShowsViewController.h"

#import "Show.h"
#import "PKEpisodesViewController.h"

@interface PKShowsViewController ()

@end

@implementation PKShowsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Show"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(name))
                                                                 ascending:YES
                                                                  selector:@selector(localizedCompare:)];
	fetchRequest.sortDescriptors = @[sortByName];
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:self.managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
	self.fetchedResultsController.delegate = self;
	NSError *fetchError = nil;
	if (![self.fetchedResultsController performFetch:&fetchError]) {
		NSLog(@"Fetch Error: %@", fetchError);
	}

	self.navigationItem.title = @"Shows";
}

#pragma mark - TableView Datasource/Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const kTableViewReuseID = @"TableViewResueID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReuseID];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:kTableViewReuseID];
	}
	
	Show *show = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = show.name;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Show *show = [self.fetchedResultsController objectAtIndexPath:indexPath];
	PKEpisodesViewController *episodeVC = [[PKEpisodesViewController alloc] initWithShow:show];
	[self.navigationController pushViewController:episodeVC animated:YES];
}

@end
