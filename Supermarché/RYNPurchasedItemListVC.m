//
//  RYNItemListTableViewController.m
//  Supermarché
//
//  Created by Ryan McNulty on 06/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNPurchasedItemListVC.h"

@interface RYNPurchasedItemListVC ()
@end

@implementation RYNPurchasedItemListVC
@synthesize list, newestItem;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) { } // Custom initialization
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add item" style:UIBarButtonItemStyleBordered target:self action:@selector(promptForNewItem)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = [list name];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadItemsFromStorage];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self autoRemovalEnabled]){
        return [[self getUnpurchasedItems] count] +1;
    }
    else {
        return [[list items] count] +1; // return the number of items within my list + 1 for the total cell
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    NSArray *itemsToShow;
    if([self autoRemovalEnabled]){
        itemsToShow = [self getUnpurchasedItems];
    }
    else{
        itemsToShow = [list.items array];
    }
    
    if(indexPath.row != 0){
        RYNPurchasedItem *selectedItem = [itemsToShow objectAtIndex:indexPath.row - 1]; // -1 to counteract the total cell at the top
        
        NSString *purStr = nil;
        bool purchased = [selectedItem.purchased boolValue];
        if(purchased){
            purStr = @"Yes";
        }
        else{
            purStr = @"No";
            NSString *subStr = [NSString stringWithFormat:@"Purchased: %@, Quanitity = %@",purStr,selectedItem.quantity];
            cell.textLabel.text = selectedItem.name;
            cell.detailTextLabel.text = subStr;
        }
    
        NSString *subStr = [NSString stringWithFormat:@"Purchased: %@, Quanitity = %@",purStr,selectedItem.quantity];
        cell.textLabel.text = selectedItem.name;
        cell.detailTextLabel.text = subStr;
    }
    else {
        double total = 0.00;
        
        // in this loop it doesn't appear to have the latest items data
        for(RYNPurchasedItem *item in list.items){
            if([item.purchased boolValue]){
                total+= ([item.price doubleValue] * [item.quantity integerValue]);
            }
        }
        
        NSString *totalStr = [NSString stringWithFormat:@"Total = £%.2f",total];
        [list setPrice:totalStr]; // Store the total too the list

        cell.textLabel.text = totalStr;
        cell.detailTextLabel.text = @"";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (NSMutableArray *)getUnpurchasedItems
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(RYNPurchasedItem *thisItem in list.items){
        if(![thisItem.purchased boolValue]){
            [array addObject:thisItem];
        }
    }

    return array;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.row !=0) {
        // Delete the row from the data source
        RYNPurchasedItem *toDelete;
        
        if([self autoRemovalEnabled]){
            toDelete = [[self getUnpurchasedItems] objectAtIndex:indexPath.row -1];  // FOR AUTO REMOVAL
        }
        else{
            toDelete = [list.items objectAtIndex:indexPath.row -1]; // compensate for total cell at the top
        }
        [toDelete MR_deleteEntity];
        [self loadItemsFromStorage];
    }    
}


- (void)promptForNewItem{
    UIAlertView* itemAlert = [[UIAlertView alloc] initWithTitle:@"Add a new item" message:@"Please enter the name of your item" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add item", nil];
    itemAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    itemAlert.tag = 0;
    
    
    // Item
    UITextField *textField = [itemAlert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocapitalizationType = TRUE;
    [itemAlert addSubview:textField];
    [itemAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        // User has just input to add an item name
        if(alertView.tag == 0){
            newestItem = [RYNPurchasedItem MR_createEntity];
            [newestItem setName:[alertView textFieldAtIndex:0].text];
            
            [alertView dismissWithClickedButtonIndex:0 animated:true];
            
            // prompt for quantity
            UIAlertView* quanAlert = [[UIAlertView alloc] initWithTitle:@"Item quantity" message:@"Please enter the quantity of the item." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add quantity", nil];
            quanAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            quanAlert.tag = 1;
            
            
            // show input for quantity
            UITextField *textField = [quanAlert textFieldAtIndex:0];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [quanAlert addSubview:textField];
            [quanAlert show];
        }
        
        // The user has input the quantity of the item
        else if(alertView.tag == 1){
            int quan = [[alertView textFieldAtIndex:0].text intValue];
            [newestItem setQuantity:[NSNumber numberWithInt:quan]];
            [newestItem setOriginalQuantity:[NSNumber numberWithInt:quan]];
            [newestItem setPurchased:false]; // all items not purchased by default
            [newestItem setPrice:[NSNumber numberWithDouble:0.00]];
            [newestItem setList:list];
            
            [self loadItemsFromStorage];
        }
    }
    [self.tableView reloadData];
    
    // close the alert
    [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 0){
        RYNPurchasedItem *selected;
        if([self autoRemovalEnabled]){
            selected = [[self getUnpurchasedItems] objectAtIndex:indexPath.row -1]; // AUTO REMOVAL

        }
        else {
            selected = [[list items] objectAtIndex:indexPath.row -1]; // minus 1 to ignore Total cell
        }
    
        UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        RYNPurchasedItemEditorVC *myViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"Purchased Item Details"];
        [myViewController setThisItem:selected];
    
        [self.navigationController pushViewController:myViewController animated:TRUE];
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


- (BOOL)autoRemovalEnabled{
    NSArray *settings = [RYNOptions MR_findAll];
    
    if([settings count]!=0){
        RYNOptions *option = [settings objectAtIndex:0];
        return [option.autoremovalEnabled boolValue];
    }
    return false;
}


- (void)loadItemsFromStorage {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        list = (RYNPurchasedList *)[[NSManagedObjectContext MR_contextForCurrentThread] existingObjectWithID:list.objectID error:nil];
        
        [self.tableView reloadData];
    }];
}

@end