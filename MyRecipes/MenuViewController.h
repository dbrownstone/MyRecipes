//
//  MenuViewController.h
//  MyRecipes
//
//  Created by David Brownstone on 8/15/14.
//  Copyright (c) 2015 DBrownstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"

@interface MenuViewController: UIViewController

@property (strong,nonatomic) NSArray *recipeArray;
@property (strong,nonatomic) IBOutlet UITableView *tableView;

@end
