//
//  RYNAppDelegate.h
//  Supermarché
//
//  Created by Ryan McNulty on 12/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
