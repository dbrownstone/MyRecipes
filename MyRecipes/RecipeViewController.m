//
//  RecipeViewController.m
//  MyRecipes
//
//  Created by David on 6/28/15.
//  Copyright (c) 2015 David Brownstone. All rights reserved.
//

#import "RecipeViewController.h"
#import "SWRevealViewController.h"
#import "XMLParser.h"

extern NSString *kAPIKEY;

@interface RecipeViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic,weak) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSDictionary *thisRecipesData;

@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *theTitle;
@property (nonatomic,weak) IBOutlet UILabel *prepTime;
@property (nonatomic,weak) IBOutlet UILabel *notes;
@property (nonatomic,weak) IBOutlet UITextView *ingredients;
@property (nonatomic,weak) IBOutlet UITextView *preparation;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealViewController setRearViewRevealWidth:300];
    self.theTitle.text = @"Recipe";
    self.prepTime.text = @"";
    self.notes.text = @"";
    self.ingredients.text = @"";
    self.preparation.text = @"";
   
    if (self.currentRecipe[@"RecipeID"]) {
        self.scrollView.hidden = NO;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.bigoven.com/recipe/%@?api_key=%@",self.currentRecipe[@"RecipeID"],kAPIKEY];
        
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n  +" options:0 error:&error];
        urlStr = [regex stringByReplacingMatchesInString:urlStr options:0 range:NSMakeRange(0, urlStr.length) withTemplate:@""];

        NSURL *url = [NSURL URLWithString:urlStr];
        
        XMLParser *parser = [[XMLParser alloc] initWithURL:url];
        
        _thisRecipesData = [[NSDictionary alloc] initWithDictionary:parser.recipeInfo];
//        
//        urlStr = _thisRecipesData[@"WebURL"];
//        urlStr = [regex stringByReplacingMatchesInString:urlStr options:0 range:NSMakeRange(0, urlStr.length) withTemplate:@""];
//        url = [NSURL URLWithString:urlStr];
//        NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:url];
//        [self.webView loadRequest:request];
        
        self.theTitle.text = _thisRecipesData[@"Title"];
        self.prepTime.text = [NSString stringWithFormat:@"Ready in %@",_thisRecipesData[@"TotalMinutes"]];
        self.notes.text = _thisRecipesData[@"PreparationNotes"];
        self.ingredients.text = _thisRecipesData[@"Ingredients"];
        self.preparation.text = _thisRecipesData[@"Instructions"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
