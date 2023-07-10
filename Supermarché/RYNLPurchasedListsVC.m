//
//  RYNListTableViewController.m
//  Supermarché
//
//  Created by Ryan McNulty on 06/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNLPurchasedListsVC.h"
#import "RYNPurchasedList.h"
#import "RYNPurchasedItemListVC.h"
#import "RYNListCreatorVC.h"


@interface RYNLPurchasedListsVC ()
@end

@implementation RYNLPurchasedListsVC
@synthesize shoppingLists;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Purchased";
    
    shoppingLists = [[NSMutableArray alloc] initWithArray:[RYNPurchasedList MR_findAllSortedBy:@"name" ascending:YES]];
}


- (void)viewWillAppear:(BOOL)animated{
    shoppingLists = [[NSMutableArray alloc] initWithArray:[RYNPurchasedList MR_findAllSortedBy:@"name" ascending:YES]];
    [self.tableView reloadData];
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
    return [RYNPurchasedList MR_countOfEntities];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RYNPurchasedList *selectedList = [shoppingLists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = selectedList.name;
    cell.detailTextLabel.text = selectedList.date;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RYNPurchasedList *selectedList = [shoppingLists objectAtIndex:indexPath.row];
        [selectedList MR_deleteEntity];
        [self loadListsFromStorage];
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYNPurchasedList *selected = [shoppingLists objectAtIndex:indexPath.row];
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    RYNPurchasedItemListVC *myViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"Purchased Items List"];
    [myViewController setList:selected];
    
    [self.navigationController pushViewController:myViewController animated:TRUE];
}


- (IBAction)addNewShoppingList:(id)sender {    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    RYNListCreatorVC *creatorWindow = [myStoryboard instantiateViewControllerWithIdentifier:@"new list"];
    [self.navigationController pushViewController:creatorWindow animated:TRUE];
}


- (void)loadListsFromStorage {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:nil];
    shoppingLists = [[NSMutableArray alloc] initWithArray:[RYNPurchasedList MR_findAllSortedBy:@"name" ascending:YES]];
    
    [self.tableView reloadData];
}

@end