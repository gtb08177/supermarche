//
//  RYNListTableViewController.h
//  Supermarché
//
//  Created by Ryan McNulty on 06/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYNLPurchasedListsVC : UITableViewController <UIAlertViewDelegate>

- (IBAction)addNewShoppingList:(id)sender;

@property (strong,nonatomic) NSMutableArray *shoppingLists;

@end
