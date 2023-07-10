//
//  RYNTemplateItemList.h
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNTemplateItem.h"
#import "RYNTemplateList.h"

@interface RYNTemplateItemListVC : UITableViewController

@property (strong,nonatomic) RYNTemplateList *list;
@property (strong,nonatomic) RYNTemplateItem *newestItem;

@end
