//
//  RYNItemListTableViewController.h
//  Supermarché
//
//  Created by Ryan McNulty on 06/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNPurchasedList.h"
#import "RYNPurchasedItem.h"
#import "RYNPurchasedItemEditorVC.h"
#import "RYNOptions.h"

@interface RYNPurchasedItemListVC : UITableViewController

@property (strong,nonatomic) RYNPurchasedList *list;
@property (strong,nonatomic) RYNPurchasedItem *newestItem;

@end
