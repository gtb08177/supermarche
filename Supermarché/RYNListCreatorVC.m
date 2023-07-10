//
//  RYNListCreatorViewController.m
//  Supermarché
//
//  Created by Ryan McNulty on 13/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNListCreatorVC.h"

@interface RYNListCreatorVC ()
@end

@implementation RYNListCreatorVC

@synthesize names,shoppingLists,templateListName, templatePicker;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

                 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shoppingLists = [[NSMutableArray alloc] initWithArray:[RYNTemplateList MR_findAllSortedBy:@"name" ascending:YES]];
    templateListName = @"None";
    self.listNameTextField.autocapitalizationType = true;
    
    // Setup UIPickerView for template lists options
    UIPickerView *templatePickerView = [[UIPickerView alloc] init];
    [templatePickerView setShowsSelectionIndicator:YES];
    
    names = [[NSMutableArray alloc] init];
    [names addObject:@"None"];
    
    for (RYNTemplateList *list in shoppingLists) {
        [names addObject:list.name];
    }
    
    [templatePickerView setDataSource:self];
    [templatePickerView setDelegate:self];
    [self.templatePicker setInputView:templatePickerView];
    
    // Add a create button to the top
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewList)];
    self.navigationItem.rightBarButtonItem = createButton;
}


- (void)createNewList{
    NSString *listName =  [self.listNameTextField text];
    
    // Only if the listName isn't empty
    if(![listName isEqualToString:@""]){
        // Create a list
        RYNPurchasedList *createdList = [RYNPurchasedList MR_createEntity];
        
        // Time stamp it
        NSDate *currentDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate]; // Get necessary date components
        
        NSString *dateStr = [NSString stringWithFormat:@"%D/%D/%D - %D:%D:%D",[components day],[components month],[components year], [components hour], [components minute],[components second]];
        
        createdList.name = listName;
        createdList.date = dateStr;
        
        // save it - removing this will cause the following methods to misbehave as lastCreatedList assumes the newly created list to be in the set it checks
        [self saveListsAndReload];
        
        
        /////////////////////////////////////////////////////    Create List from List   ////////////////////////////////////////////////////
        [self checkForTemplate:createdList];
                
        /////////////////////////////////////////////////////    Shop Mem config   ////////////////////////////////////////////////////   
        [self addPreviousUnpurchased:createdList];

        // Save and push back to list view 
        [self saveListsAndReload];
        [[self navigationController] popViewControllerAnimated:TRUE];
    }
    else {
        // Show a warning
        UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must provide a name for the list" delegate:self cancelButtonTitle:@"I understand" otherButtonTitles:nil,nil];
        [warning show];
    }
}


/* Shopping Mem Config code */
- (void)addPreviousUnpurchased:(RYNPurchasedList *)createdList
{
    if([self shopMemEnabled]){
        RYNPurchasedList *lastCreatedList = [self lastCreatedList:createdList];
    
        if(lastCreatedList!= nil){
            for(RYNPurchasedItem *item in lastCreatedList.items){
                if(!item.purchased){
                    // they did not buy this item
                    RYNPurchasedItem *newItem = [RYNPurchasedItem MR_createEntity];
                    
                    newItem.name = item.name;
                    newItem.quantity = item.originalQuantity;
                    newItem.originalQuantity = item.originalQuantity;
                
                    [newItem setList:createdList];
                }
                else {
                    // If they purchased the item but the quan they bought was LESS than what they originally put, transfer the difference.
                    if([item.quantity intValue] < [item.originalQuantity intValue]){
                        RYNPurchasedItem *newItem = [RYNPurchasedItem MR_createEntity];
                    
                        NSNumber *amountToBuy =  [NSNumber numberWithInt:([item.originalQuantity intValue] - [item.quantity intValue])];
                    
                        newItem.name = item.name;
                        newItem.quantity = amountToBuy;
                        newItem.originalQuantity = amountToBuy;
                        
                        [newItem setList:createdList];
                    }
                }
            }
        }
    }
}


/* Returns the list created before the param passed one */
- (RYNPurchasedList *)lastCreatedList:(RYNPurchasedList *)createdList
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
                NSDate *creatingListDate = [dateFormatter dateFromString:createdList.date];
                
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


- (BOOL)shopMemEnabled{
    NSArray *settings = [RYNOptions MR_findAll];

    if([settings count]!=0){
        RYNOptions *option = [settings objectAtIndex:0];
        return [option.shopMemEnabled boolValue];
    }
    return false;
}


- (void)checkForTemplate:(RYNPurchasedList *)createdList
{
    // If they selected a template list
    if(![templateListName isEqualToString:@"None"]){
        RYNTemplateList *templateList = nil;
        
        // Find the template list
        for (RYNTemplateList *list in shoppingLists) {
            if([list.name isEqualToString:templateListName]){
                templateList = list;
            }
        }
        
        // Create new items for the new list based on the items contained on the template list
        for (RYNTemplateItem *item in templateList.items){
            RYNPurchasedItem *clone = [RYNPurchasedItem MR_createEntity];
            
            clone.name = item.name;
            clone.quantity = item.quantity;
            clone.originalQuantity = item.quantity; // used for shop mem spec
            [clone setList:createdList]; // was clone.list = createdList
        }
        templateListName = @"None";
    }
}


- (void)saveListsAndReload {
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:nil];
    shoppingLists = [[NSMutableArray alloc] initWithArray:[RYNTemplateList MR_findAllSortedBy:@"name" ascending:YES]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [names count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [names objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    templateListName = [names objectAtIndex:row];
    templatePicker.text = [names objectAtIndex:row];
}

@end