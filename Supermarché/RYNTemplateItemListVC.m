//
//  RYNTemplateItemList.m
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNTemplateItemListVC.h"
#import "RYNTemplateItem.h"
#import "RYNTemplateItemEditorVC.h"



@interface RYNTemplateItemListVC ()
@end

@implementation RYNTemplateItemListVC
@synthesize list, newestItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add item" style:UIBarButtonItemStyleBordered target:self action:@selector(promptForNewItem)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.title = [list name];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    return [list.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RYNTemplateItem *selectedItem = [list.items objectAtIndex:indexPath.row]; 
    
    NSString *subStr = [NSString stringWithFormat:@"Quanitity = %@",selectedItem.quantity];
    cell.textLabel.text = selectedItem.name;
    cell.detailTextLabel.text = subStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RYNTemplateItem *toDelete = [list.items objectAtIndex:indexPath.row];
        [toDelete MR_deleteEntity];
        [self loadItemsFromStorage];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYNTemplateItem *selected = [[list items] objectAtIndex:indexPath.row]; 
    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    RYNTemplateItemEditorVC *myViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"Template Item Details"];
    [myViewController setThisItem:selected];
    
    [self.navigationController pushViewController:myViewController animated:TRUE];
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
            newestItem = [RYNTemplateItem MR_createEntity];
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
            [newestItem setList:list];
            
            [self loadItemsFromStorage];
        }
    }
    [self.tableView reloadData];
    
    // close the alert
    [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
}


- (void)loadItemsFromStorage {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        list = (RYNTemplateList *)[[NSManagedObjectContext MR_contextForCurrentThread] existingObjectWithID:list.objectID error:nil];
        
        [self.tableView reloadData];
    }];
}

@end