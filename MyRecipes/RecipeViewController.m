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
@property (nonatomic,weak) IBOutlet UIView *scrollContentView;
@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *theTitle;
@property (nonatomic,weak) IBOutlet UILabel *prepTime;
@property (nonatomic,weak) IBOutlet UITextView *notes;
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
    self.theTitle.text = @"";
    self.prepTime.text = @"";
    self.notes.text = @"";
    self.ingredients.text = @"";
    self.preparation.text = @"";
   
    if (self.currentRecipe[@"RecipeID"]) {
        NSLog(@"%@",self.currentRecipe);
        self.scrollView.hidden = NO;
        NSString *urlStr = [NSString stringWithFormat:@"http://api.bigoven.com/recipe/%@?api_key=%@",self.currentRecipe[@"RecipeID"],kAPIKEY];
        
        urlStr = [self removeNewLinesFromString:urlStr];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        XMLParser *parser = [[XMLParser alloc] initWithURL:url];
        
        _thisRecipesData = [[NSDictionary alloc] initWithDictionary:parser.recipeInfo];
        
        UINavigationItem * navItem = self.navigationItem;
        navItem.rightBarButtonItem.enabled = YES;
        
        NSLog(@"%@",self.thisRecipesData);
        self.theTitle.text = [self removeNewLinesFromString:_thisRecipesData[@"Title"]];
        self.prepTime.text = [self removeNewLinesFromString:[NSString stringWithFormat:@"Ready in %@ minutes",_thisRecipesData[@"TotalMinutes"]]];
        self.notes.text = _thisRecipesData[@"Description"];
        [self.notes sizeToFit];
        self.ingredients.text = _thisRecipesData[@"Ingredients"];
        [self.ingredients sizeToFit];
        self.preparation.text = _thisRecipesData[@"Instructions"];
        [self.preparation sizeToFit];
        
        float sizeOfContent = 0;
        int i;
        for (i = 0; i < [_scrollContentView.subviews count]; i++) {
            UIView *view =[_scrollContentView.subviews objectAtIndex:i];
            sizeOfContent += view.frame.size.height;
        }

        self.scrollView.contentSize = [_scrollView sizeThatFits:_scrollView.frame.size];//CGSizeMake(self.scrollContentView.frame.size.width,sizeOfContent);
    }
}

-(NSString *)removeNewLinesFromString:(NSString *)text {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n  +" options:0 error:&error];
    return [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
}

- (IBAction)showURL {
    self.scrollView.hidden = YES;
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n  +" options:0 error:&error];
    NSString *urlStr = _thisRecipesData[@"WebURL"];
    urlStr = [regex stringByReplacingMatchesInString:urlStr options:0 range:NSMakeRange(0, urlStr.length) withTemplate:@""];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.currentRecipe[@"RecipeID"]) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
