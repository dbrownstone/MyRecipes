//
//  ViewController.m
//  MyRecipes
//
//  Created by David on 6/28/15.
//  Copyright (c) 2015 David Brownstone. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"

@interface ViewController ()<UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self.revealViewController setRearViewRevealWidth:300];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
