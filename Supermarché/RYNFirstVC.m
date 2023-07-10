//
//  RYNFirstVC.m
//  Supermarché
//
//  Created by Ryan McNulty on 16/03/2013.
//  Copyright (c) 2013 Ryan McNulty. All rights reserved.
//

#import "RYNFirstVC.h"

@interface RYNFirstVC ()
@end

@implementation RYNFirstVC
@synthesize listOptions;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Supermarché";
    
    listOptions = [[NSMutableArray alloc] init];
    [listOptions addObject:@"Template Lists"];
    [listOptions addObject:@"Purchased Lists"];
    
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
    return [listOptions count]; // Made lists and purchased lists
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [listOptions objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UITableViewController *nextController;
    
    if(indexPath.row == 0){
        // They selected template lists
        nextController = [myStoryboard instantiateViewControllerWithIdentifier:@"Template Lists"];

    }
    else{
        // They selected purchased lists
        nextController = [myStoryboard instantiateViewControllerWithIdentifier:@"Purchased Lists"];
    }
    
    [self.navigationController pushViewController:nextController animated:YES];
}

- (IBAction)settingsBarButton:(id)sender {
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    UIViewController *settingsVC = [myStoryboard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}
@end
