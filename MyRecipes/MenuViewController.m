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

typedef enum
{
    kInternet = 0,
    kFavorites = 1,
    kAll = 2
} kSearchScopeOptions;

@interface MenuViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic) BOOL changeStoryboard;
@property IBOutlet UISearchBar *recipeSearchBar;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"Internet",@"Internet"),NSLocalizedString(@"Favorites",@"Favorites"),NSLocalizedString(@"All",@"All")];
    [self.searchController.searchBar showsCancelButton];
    [self.searchController.searchBar showsScopeBar];
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    self.definesPresentationContext = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self searchBar:self.recipeSearchBar selectedScopeButtonIndexDidChange:0];

    [self.searchController.searchBar becomeFirstResponder];
    [self.navigationController setToolbarHidden:YES animated:NO];
    // Reload the table
    [self.tableView reloadData];
    [self.revealViewController setRearViewRevealWidth:320];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSUInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if ([_recipeArray count] > 0) {
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
    if (_recipeArray) {
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
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scopeIndex {
    NSString *urlStr = [NSString stringWithFormat:@"http://api.bigoven.com/recipes?title_kw=%@&pg=1&rpp=20&api_key=%@",searchText,kAPIKEY];
    NSURL *URL = [NSURL URLWithString:urlStr];
    XMLParser *parser = [[XMLParser alloc] initWithURL:URL];
    
    _recipeArray = parser.recipeList;
}

#pragma mark - UISearchControllerDelegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    [self.revealViewController setRearViewRevealWidth:500];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(![searchBar isFirstResponder] || [searchBar.text length] == 0) {
        // user tapped the 'clear' button
        [searchBar becomeFirstResponder];
//        [self.revealViewController setFrontViewRevealWidth:320];
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        // do whatever I want to happen when the user clears the search...
    } else {
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if ([searchBar.text length] == 0) {
        return NO;
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}

@end
