//
//  CCShot.h
//  Crossover
//
//  Created by Cornelius Carl on 04.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DribbblePlayer.h"

@interface DribbbleShot : NSObject

@property (nonatomic) NSInteger identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *URL; // Automatically @2x for retina devices
@property (nonatomic, strong) NSURL *shortURL; // For sharing
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic) NSInteger viewsCount;
@property (nonatomic) NSInteger likesCount;
@property (nonatomic) NSInteger reboundsCount;
@property (nonatomic) NSInteger reboundsSourceIdentifier;
@property (nonatomic, strong) DribbblePlayer *player;
@property (nonatomic, strong) NSDate *creationDate;

@end
