//
//  RYNSettingsVC.m
//  Supermarché
//
//  Created by Ryan McNulty on 19/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNSettingsVC.h"
#import "RYNOptions.h"


@interface RYNSettingsVC ()

@end

@implementation RYNSettingsVC
@synthesize shopMemSwitch, priceCompSwitch,autoremovalSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self updateShopMemSwitch];
        [self updatePriceCompSwitch];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateShopMemSwitch];
    [self updatePriceCompSwitch];
    [self updateAutoremovalSwitch];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/******************************************** GET OPTION STATUS FROM MEM ************************************/
- (BOOL)getShopMemEnabledStatus {
    RYNOptions *option = [self getOptionsObject];
    return [option.shopMemEnabled boolValue];
}

- (BOOL)getPriceCompEnabledStatus {
    RYNOptions *option = [self getOptionsObject];
    return [option.priceCompEnabled boolValue];
}

- (BOOL)getAutoremovalEnabledStatus {
    RYNOptions *option = [self getOptionsObject];
    return [option.autoremovalEnabled boolValue];
}


/******************************************* UPDATE SWITCHES METHODS ***************************************/
- (void)updateShopMemSwitch
{
    [shopMemSwitch setOn:[self getShopMemEnabledStatus]];
}


- (void)updatePriceCompSwitch
{
    [priceCompSwitch setOn:[self getPriceCompEnabledStatus]];
}


- (void)updateAutoremovalSwitch
{
    [autoremovalSwitch setOn:[self getAutoremovalEnabledStatus]];
}

/****************************************** ACTION METHODS *******************************************/
- (IBAction)priceCompSwitchToggled:(id)sender {
    RYNOptions *option = [self getOptionsObject];
    
    [option setPriceCompEnabled:[NSNumber numberWithBool:![option.priceCompEnabled boolValue]]];
    printf("priceComp has been %d",[option.priceCompEnabled boolValue]);
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:nil];
}


- (IBAction)shopMemSwitchToggled:(id)sender {
    RYNOptions *option = [self getOptionsObject];
    
    [option setShopMemEnabled:[NSNumber numberWithBool:![option.shopMemEnabled boolValue]]];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:nil];
}

- (IBAction)autoremovalSwitchToggled:(id)sender {
    RYNOptions *option = [self getOptionsObject];
    
    [option setAutoremovalEnabled:[NSNumber numberWithBool:![option.autoremovalEnabled boolValue]]];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:nil];
}





- (RYNOptions *)getOptionsObject
{
    NSArray *coll = [RYNOptions MR_findAll];
    RYNOptions *option = [coll objectAtIndex:0]; // Only one will ever exist
    return option;
}
@end
