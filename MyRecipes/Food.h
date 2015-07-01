//
//  Food.h
//  
//
//  Created by David on 6/30/15.
//
//

#import <Foundation/Foundation.h>

@interface Food : NSObject

@property (nonatomic, copy) NSString *recipeID;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *subCategory;
@property (nonatomic, copy) NSString *cuisine;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rating;
@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, copy) NSString *photoURL;

+ (id)foodOfCategory:(NSMutableDictionary *)dict;

@end
