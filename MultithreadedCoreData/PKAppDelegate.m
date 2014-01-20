//
//  PKAppDelegate.m
//  MultithreadedCoreData
//
//  Created by Robert Edwards on 1/20/14.
//  Copyright (c) 2014 Panko. All rights reserved.
//

#import "PKAppDelegate.h"

#import "PKShowsViewController.h"
#import "PKBackgroundDataInsertionController.h"

@implementation PKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	PKShowsViewController *showsVC = [[PKShowsViewController alloc] init];
	UINavigationController *baseNavController = [[UINavigationController alloc] initWithRootViewController:showsVC];
	self.window.rootViewController = baseNavController;
	
	[[PKBackgroundDataInsertionController sharedInstance] beginSampleInsertOrUpdateSync];
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end
