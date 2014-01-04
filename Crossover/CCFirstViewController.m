//
//  CCFirstViewController.m
//  Crossover
//
//  Created by Cornelius Carl on 03.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import "CCFirstViewController.h"

#import "CCDribbbleAPI.h"

@interface CCFirstViewController ()

@end

@implementation CCFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[CCDribbbleAPI sharedAPI] getShotsForList:CCDribbbleListTypePopular withCompletionBlock:^(NSArray *shotsArray) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
