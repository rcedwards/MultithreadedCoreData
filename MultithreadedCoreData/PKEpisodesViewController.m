//
//  PKEpisodesViewController.m
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKEpisodesViewController.h"

#import "Show.h"
#import "Episode.h"

@interface PKEpisodesViewController ()

@property (strong, nonatomic) Show *show;

@end

@implementation PKEpisodesViewController

- (id)init {
	useDesignatedInitializer();
}

- (id)initWithShow:(Show *)show {
	if (self = [super init]) {
		_show = show;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = self.show.name;
}

#pragma mark - Overrides

- (NSFetchedResultsController *)fetchedResultsController {
	if (!_fetchedResultsController) {
		NSPredicate *showEpisodesList = [NSPredicate predicateWithFormat:@"show == %@", self.show];
		
        NSSortDescriptor *seasonNumberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"season.number"
																					 ascending:YES
                                                                                      selector:@selector(localizedStandardCompare:)];
        
        NSSortDescriptor *episodeNumberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"seasonNumber"
																					  ascending:YES];
        
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Episode"];
		fetchRequest.sortDescriptors = @[seasonNumberSortDescriptor, episodeNumberSortDescriptor];
		fetchRequest.predicate = showEpisodesList;
		_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																		managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"Season"
																				   cacheName:nil];
        _fetchedResultsController.delegate = self;
		NSError *fetchError = nil;
		if (![_fetchedResultsController performFetch:&fetchError]) {
			PLog(@"Fetch Error: %@", fetchError);
		}
	}
	return _fetchedResultsController;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *const kTableViewReuseID = @"EpisodeViewResueID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReuseID];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:kTableViewReuseID];
	}
	
	Episode *episode = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Airing: %@", episode.airDate];
	cell.textLabel.text = episode.name;
	
	return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@ %d", self.fetchedResultsController.sectionNameKeyPath, (int)section+1];
}

@end
