//
//  Recipe.m
//  
//
//  Created by David on 6/30/15.
//
//

#import "Recipe.h"

@implementation Recipe

+ (id)recipeOfCategory:(NSMutableDictionary *)dict{
    Recipe *newRecipe = [[self alloc] init];
    newRecipe.recipeID = [[dict[@"RecipeID"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.name = [[dict[@"Title"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.category = [[dict[@"Category"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.subCategory = [[dict[@"Subcategory"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.cuisine = [[dict[@"Cuisine"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.rating = [[dict[@"StarRating"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.webURL = [[dict[@"WebURL"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.photoURL = [[dict[@"HeroPhotURL"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newRecipe.favorite = NO;
    return newRecipe;
}
@end
