//
//  RYNTemplateLists.m
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNTemplateListsVC.h"
#import "RYNTemplateList.h"
#import "RYNTemplateItemListVC.h"
#import "RYNListCreatorVC.h"


@interface RYNTemplateListsVC ()
@end

@implementation RYNTemplateListsVC
@synthesize templateLists;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Template";
    
    templateLists = [[NSMutableArray alloc] initWithArray:[RYNTemplateList MR_findAllSortedBy:@"name" ascending:YES]];
}

- (void)viewWillAppear:(BOOL)animated{
    templateLists = [[NSMutableArray alloc] initWithArray:[RYNTemplateList MR_findAllSortedBy:@"name" ascending:YES]];
    
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
    return [RYNTemplateList MR_countOfEntities];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RYNTemplateList *selectedList = [templateLists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = selectedList.name;
    cell.detailTextLabel.text = selectedList.date;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RYNTemplateList *selectedList = [templateLists objectAtIndex:indexPath.row];
        [selectedList MR_deleteEntity];
        [self loadListsFromStorage];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYNTemplateList *selected = [templateLists objectAtIndex:indexPath.row];
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    RYNTemplateItemListVC *myViewController = [myStoryboard instantiateViewControllerWithIdentifier:@"Template Items List"];
    [myViewController setList:selected];
    
    [self.navigationController pushViewController:myViewController animated:TRUE];
}

- (IBAction)addNewShoppingList:(id)sender {    
//    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    RYNListCreatorVC *creatorWindow = [myStoryboard instantiateViewControllerWithIdentifier:@"new list"];
//    
//    [self.navigationController pushViewController:creatorWindow animated:TRUE];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New shopping list?" message:@"The name of your shopping list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create new list", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 0;

    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocapitalizationType = TRUE;
    [alert addSubview:textField];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex != 0){
        if(alertView.tag == 0){
            NSString *listName =  [alertView textFieldAtIndex:0].text;

            NSDate *currentDate = [NSDate date];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components

            NSString *dateStr = [NSString stringWithFormat:@"%D/%D/%D",[components day],[components month],[components year]];

            RYNTemplateList *myNewList = [RYNTemplateList MR_createEntity];
            myNewList.name = listName;
            myNewList.date = dateStr;

            [self loadListsFromStorage];
        }
    }
    // close the alert
    [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
}


- (void)loadListsFromStorage {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:nil];
    templateLists = [[NSMutableArray alloc] initWithArray:[RYNTemplateList MR_findAllSortedBy:@"name" ascending:YES]];
    
    [self.tableView reloadData];
}

@end