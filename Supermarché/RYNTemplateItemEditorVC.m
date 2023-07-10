//
//  RYNTemplateItemEditorVC.m
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNTemplateItemEditorVC.h"

@interface RYNTemplateItemEditorVC ()
@end

@implementation RYNTemplateItemEditorVC

@synthesize nameLabel,quantityLabel,quantityStepper, thisItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)changeQuantity:(id)sender {
    NSNumber *newQuantity = [NSNumber numberWithDouble:[(UIStepper *)sender value]];
    thisItem.quantity = newQuantity;
    quantityLabel.text = [NSString stringWithFormat:@"%d",[newQuantity intValue]];
    
    [self saveItem];
}


- (void)saveItem {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        thisItem = (RYNTemplateItem *)[[NSManagedObjectContext MR_contextForCurrentThread] existingObjectWithID:thisItem.objectID error:nil];
    }];
}

@end
