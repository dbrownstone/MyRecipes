//
//  Candy.m
//  
//
//  Created by David on 6/30/15.
//
//

#import "Food.h"

@implementation Food

+ (id)foodOfCategory:(NSMutableDictionary *)dict{
    Food *newFood = [[self alloc] init];
    newFood.recipeID = [[dict[@"RecipeID"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.name = [[dict[@"Title"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.category = [[dict[@"Category"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.subCategory = [[dict[@"Subcategory"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.cuisine = [[dict[@"Cuisine"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.rating = [[dict[@"StarRating"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.webURL = [[dict[@"WebURL"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    newFood.photoURL = [[dict[@"HeroPhotURL"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    return newFood;
}
@end
