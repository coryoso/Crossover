//
//  CCPlayer.h
//  Crossover
//
//  Created by Cornelius Carl on 04.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DribbblePlayer : NSObject

@property (nonatomic) NSInteger identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *twitterScreenName;
@property (nonatomic, strong) NSString *draftedByPlayerIdentifer;
@property (nonatomic) NSInteger shotsCount;
@property (nonatomic) NSInteger drafteesCount;
@property (nonatomic) NSInteger followersCount;
@property (nonatomic) NSInteger followingCount;
@property (nonatomic) NSInteger commentsCount;
@property (nonatomic) NSInteger commentsReceivedCount;
@property (nonatomic) NSInteger likesCount;
@property (nonatomic) NSInteger likesReceivedCount;
@property (nonatomic) NSInteger reboundsCount;
@property (nonatomic) NSInteger reboundsReceivedCount;
@property (nonatomic, strong) NSDate *creationDate;

@end
