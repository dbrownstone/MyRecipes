//
//  MenuViewController.m
//  MyRecipes
//
//  Created by David Brownstone on 8/15/14.
//  Copyright (c) 2014 Snebold. All rights reserved.
//

#import "MenuViewController.h"
#import "RecipeViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "XMLParser.h"

NSString const *kAPIKEY=@"dvxBKsJ2k4iu2em3dBtcYbVMdJoLwp4s";

@interface MenuViewController ()

@property (nonatomic) BOOL changeStoryboard;
@property IBOutlet UISearchBar *recipeSearchBar;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.recipeSearchBar sizeToFit];
    self.searchDisplayController.active = YES;
    [self searchBar:self.recipeSearchBar selectedScopeButtonIndexDidChange:0];
    [self.navigationController setToolbarHidden:YES animated:NO];
    // Reload the table
    [self.tableView reloadData];

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
        return [_recipeArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"basicMenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Create a new Food Object
    Recipe *recipe = nil;
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        recipe = [Recipe recipeOfCategory:[_recipeArray objectAtIndex:indexPath.row]];
    }

    // Configure the cell
    NSString *someString = [NSString stringWithFormat:@"%@",recipe.name];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:0 error:&error];
    cell.textLabel.text = [regex stringByReplacingMatchesInString:someString options:0 range:NSMakeRange(0, someString.length) withTemplate:@" "];
    cell.detailTextLabel.text = recipe.category;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"displayRecipe" sender:indexPath];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [sender isKindOfClass:[NSIndexPath class]] )
    {
        UINavigationController *navController = segue.destinationViewController;
        RecipeViewController *vc = [navController childViewControllers].firstObject;
        //UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSDictionary *recipe = [_recipeArray objectAtIndex:indexPath.row];
        vc.currentRecipe = recipe;
    }
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSString *urlStr = [NSString stringWithFormat:@"http://api.bigoven.com/recipes?title_kw=%@&pg=1&rpp=20&api_key=%@",searchText,kAPIKEY];
    NSURL *URL = [NSURL URLWithString:urlStr];
    XMLParser *parser = [[XMLParser alloc] initWithURL:URL];
    
    _recipeArray = parser.recipeList;
}

#pragma mark - UISearchControllerDelegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
}
    
-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[controller.searchBar scopeButtonTitles] objectAtIndex:[controller.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:controller.searchBar.text scope: [[controller.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
