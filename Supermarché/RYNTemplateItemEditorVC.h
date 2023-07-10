//
//  RYNTemplateItemEditorVC.h
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNTemplateItem.h"

@interface RYNTemplateItemEditorVC : UIViewController

@property (strong,nonatomic) RYNTemplateItem *thisItem;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;

- (IBAction)changeQuantity:(id)sender;

@end
