//
//  MenuViewController.m
//  MyRecipes
//
//  Created by David Brownstone on 8/15/14.
//  Copyright (c) 2014 Snebold. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "XMLParser.h"

NSString const *kAPIKEY=@"dvxBKsJ2k4iu2em3dBtcYbVMdJoLwp4s";

@interface MenuViewController ()

@property (nonatomic) BOOL changeStoryboard;
@property (strong,nonatomic) NSMutableArray *filteredFoodArray;
@property IBOutlet UISearchBar *candySearchBar;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSString *urlStr = [NSString stringWithFormat:@"http://api.bigoven.com/recipes?title_kw=%@&api_key=%@",@"marinades&pg=1&rpp=20",kAPIKEY];
    XMLParser *parser = [[XMLParser alloc] initWithURL:urlStr];
    
    _foodsArray = parser.recipeList;
    self.filteredFoodArray = [NSMutableArray arrayWithCapacity:[self.foodsArray count]];
    // Reload the table
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredFoodArray count];
    } else {
        return [_foodsArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Create a new Food Object
    Food *food = nil;
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        food = [_filteredFoodArray objectAtIndex:indexPath.row];
    } else {
        food = [Food foodOfCategory:[_foodsArray objectAtIndex:indexPath.row]];
    }

    // Configure the cell
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@, %@)",food.name, food.cuisine, food.category];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredFoodArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    self.filteredFoodArray = [NSMutableArray arrayWithArray:[self.foodsArray filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
