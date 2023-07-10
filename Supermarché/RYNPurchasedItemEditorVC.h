//
//  RYNItemViewController.h
//  Supermarché
//
//  Created by Ryan McNulty on 07/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNPurchasedItem.h"
#import "RYNPurchasedList.h"
#import "RYNOptions.h"

@interface RYNPurchasedItemEditorVC : UIViewController

@property (strong,nonatomic) RYNPurchasedItem *thisItem;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *purchasedSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

- (IBAction)changeQuantity:(id)sender;
- (IBAction)changePurchasedState:(id)sender;
- (IBAction)priceUpdate:(id)sender;

@end
