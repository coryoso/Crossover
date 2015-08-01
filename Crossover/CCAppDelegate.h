//
//  CCAppDelegate.h
//  Crossover
//
//  Created by Cornelius Carl on 03.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCPopularShotsViewController.h"
#import "CCFirstViewController.h"

@interface CCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *popularShotsNavigationController;
@property (strong, nonatomic) CCPopularShotsViewController *popularShotsViewController;

@property (strong, nonatomic) CCFirstViewController *firstViewController;

@end
