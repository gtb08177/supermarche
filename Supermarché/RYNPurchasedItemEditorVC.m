//
//  RYNItemViewController.m
//  Supermarché
//
//  Created by Ryan McNulty on 07/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNPurchasedItemEditorVC.h"

@interface RYNPurchasedItemEditorVC ()
@end


@implementation RYNPurchasedItemEditorVC

@synthesize nameLabel;
@synthesize quantityLabel;
@synthesize purchasedSwitch;
@synthesize quantityStepper;
@synthesize thisItem;
@synthesize priceTextField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }// Custom initialization 
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    nameLabel.text = thisItem.name;
    
    // Set quan label and stepper values
    NSString *quantity = [NSString stringWithFormat:@"%@",thisItem.quantity];
    quantityLabel.text = quantity;
    [quantityStepper setValue:[thisItem.quantity doubleValue]];
    
    // Set the switch to represent the items purchased status
    [purchasedSwitch setOn:[thisItem.purchased boolValue] animated:true];
    [priceTextField setText:[NSString stringWithFormat:@"%.2f",[thisItem.price doubleValue]]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [priceTextField resignFirstResponder];
    [self checkPriceComp]; // in case they hit purchased then enter price
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    // valueChanged outlet action 'priceupdate' doesn't work hence done here instead
//    [thisItem setPrice:[NSNumber numberWithDouble:[priceTextField.text doubleValue]]];
//    [self saveItem];
}


- (void)checkPriceComp
{
    if([self priceCompEnabled]){
        RYNPurchasedList *prevList = [self lastCreatedList];
        
        for(RYNPurchasedItem *prevPurItem in prevList.items){
            if([prevPurItem.name isEqualToString:thisItem.name] && [prevPurItem.purchased boolValue] && [thisItem.purchased boolValue]){
                printf("Prev price = %f",[prevPurItem.price floatValue]);
                printf("This price = %f",[thisItem.price floatValue]);
                bool wasCheaper = [thisItem.price floatValue] < [prevPurItem.price floatValue];
                
                UIAlertView *alertDialog;
                if(wasCheaper){
                    alertDialog = [[UIAlertView alloc] initWithTitle:@"Happy savings" message:@"You have bought this item cheaper than you did previously, well done" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                }
                else{
                    alertDialog = [[UIAlertView alloc] initWithTitle:@"Uh oh" message:@"This item price is more expensive than when you last got it" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                }
                [alertDialog show];
            }
        }
    }
}


- (BOOL)priceCompEnabled{
    NSArray *settings = [RYNOptions MR_findAll];
    
    if([settings count]!=0){
        RYNOptions *option = [settings objectAtIndex:0];
        return [option.priceCompEnabled boolValue];
    }
    return false;
}


/* Returns the list created before the param passed one */
- (RYNPurchasedList *)lastCreatedList
{
    NSMutableArray *purchasedLists = [[NSMutableArray alloc] initWithArray:[RYNPurchasedList MR_findAllSortedBy:@"name" ascending:YES]];
    int numberOfPurchasedLists = [purchasedLists count] - 1; // The new list we are creating is now counted so deduct 1
    
    RYNPurchasedList *newestListSoFar = nil;
    
    if(numberOfPurchasedLists != 0){
        for(RYNPurchasedList *purList in purchasedLists){
            // If no latest is set, take the first.
            if(newestListSoFar == nil){
                newestListSoFar = purList;
            }
            else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy - HH:mm:ss"];
                
                NSDate *newestDateSoFar = [dateFormatter dateFromString:newestListSoFar.date];
                NSDate *purDate = [dateFormatter dateFromString:purList.date];
                NSDate *creatingListDate = [dateFormatter dateFromString:thisItem.list.date];
                
                // if the current list is later than the newest so far and the creatingList is later than it too i.e. we aren't referring the the created list in purDate
                if ([purDate timeIntervalSince1970] > [newestDateSoFar timeIntervalSince1970] && [creatingListDate timeIntervalSince1970] > [purDate timeIntervalSince1970]){
                    // reset the current best
                    newestListSoFar = purList;
                }
            }
        }
    }
    return newestListSoFar;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)saveItem {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        thisItem = (RYNPurchasedItem *)[[NSManagedObjectContext MR_contextForCurrentThread] existingObjectWithID:thisItem.objectID error:nil];
    }];
}

/**************************** ACTIONS METHODS ********************/
- (IBAction)changeQuantity:(id)sender {
    NSNumber *newQuantity = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
    thisItem.quantity = newQuantity;
    quantityLabel.text = [NSString stringWithFormat:@"%d",[newQuantity intValue]];
    
    [self saveItem];
}


- (IBAction)changePurchasedState:(id)sender {
    [thisItem setPurchased:[NSNumber numberWithBool:[purchasedSwitch isOn]]];
    [self saveItem];
    
    [self checkPriceComp];

}


- (IBAction)priceUpdate:(id)sender {
    [thisItem setPrice:[NSNumber numberWithDouble:[priceTextField.text doubleValue]]];
    [self saveItem];
}

@end