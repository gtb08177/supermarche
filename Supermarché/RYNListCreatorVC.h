//
//  RYNListCreatorViewController.h
//  Supermarché
//
//  Created by Ryan McNulty on 13/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYNTemplateList.h"
#import "RYNTemplateItem.h"
#import "RYNPurchasedList.h"
#import "RYNPurchasedItem.h"
#import "RYNOptions.h"


@interface RYNListCreatorVC : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *listNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *templatePicker;
@property (strong,nonatomic) NSString *templateListName;

@property (strong, nonatomic) NSMutableArray *names;
@property (strong,nonatomic) NSMutableArray *shoppingLists;

@end
