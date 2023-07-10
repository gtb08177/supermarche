//
//  RYNFirstVC.h
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNLPurchasedListsVC.h"

@interface RYNFirstVC : UITableViewController

- (IBAction)settingsBarButton:(id)sender;

@property (strong,nonatomic) NSMutableArray *listOptions;

@end
