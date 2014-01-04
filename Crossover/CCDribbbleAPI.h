//
//  CCDribbbleAPI.h
//  Crossover
//
//  Created by Cornelius Carl on 03.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CCDribbbleListTypeDebuts,
    CCDribbbleListTypeEveryOne,
    CCDribbbleListTypePopular = 0
} CCDribbbleListType;

@interface CCDribbbleAPI : NSObject

+ (instancetype)sharedAPI;

- (void)getShotsForList:(CCDribbbleListType)listType withCompletionBlock:(void (^)(NSArray *shotsArray))completionBlock;

@end
