//
//  RYNTemplateLists.h
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYNTemplateListsVC : UITableViewController

- (IBAction)addNewShoppingList:(id)sender;

@property (strong,nonatomic) NSMutableArray *templateLists;

@end
