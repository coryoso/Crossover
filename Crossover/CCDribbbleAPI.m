//
//  CCDribbbleAPI.m
//  Crossover
//
//  Created by Cornelius Carl on 03.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import "CCDribbbleAPI.h"
#import "JSONKit.h"

#import "DribbbleShot.h"
#import "DribbblePlayer.h"

@interface CCDribbbleAPI ()
{
    NSString *baseURLString;
}

@end

@implementation CCDribbbleAPI

+ (instancetype)sharedAPI
{
    static CCDribbbleAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[self alloc] init];
    });
    
    return _sharedAPI;
}

- (id)init
{
    self = [super init];
    if (self) {
        baseURLString = @"http://api.dribbble.com/";
    }
    
    return self;
}

- (void)getShotsForList:(DribbbleListType)listType withCompletionBlock:(void (^)(NSArray *shotsArray))completionBlock
{
    NSMutableString *additionString = [NSMutableString stringWithString:@"shots/"];
    if (listType == DribbbleListTypePopular) {
        [additionString appendString:@"popular"];
    } else if (listType == DribbbleListTypeDebuts) {
        [additionString appendString:@"debuts"];
    } else {
        [additionString appendString:@"everyone"];
    }
    
    [self performRequestForURL:additionString andCallback:^(NSDictionary *returnDictionary, NSError *error) {
        //TODO pagination
         NSMutableArray *mutableShotsArray = [NSMutableArray new];
        [returnDictionary[@"shots"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *currentExternalShot = obj;
            DribbbleShot *shot = [DribbbleShot new];
            shot.identifier = [currentExternalShot[@"id"] integerValue];
            shot.title = currentExternalShot[@"title"];
            shot.URL = [NSURL URLWithString:currentExternalShot[@"url"]]; //TODO @2x
            shot.shortURL = [NSURL URLWithString:currentExternalShot[@"short_url"]];
            shot.imageURL = [NSURL URLWithString:currentExternalShot[@"image_url"]];
            shot.viewsCount = [currentExternalShot[@"views_count"] integerValue];
            shot.likesCount = [currentExternalShot[@"likes_count"] integerValue];
            shot.reboundsCount = [currentExternalShot[@"rebounds_count"] integerValue];
            NSLog(@"%@", currentExternalShot[@"image_url"]);
            if (currentExternalShot[@"rebounds_source_id"]) {
            if (![currentExternalShot[@"rebound_source_id"] isEqualToString:@"<null>"]) {
                shot.reboundsSourceIdentifier = [currentExternalShot[@"rebound_source_id"] integerValue];
            }
            }
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss ZZZ"];
            shot.creationDate = [dateFormatter dateFromString:currentExternalShot[@"created_at"]];
            
            [mutableShotsArray addObject:shot];
        }];
        NSArray *resultArray = mutableShotsArray;
        completionBlock(resultArray);
    }];
}

#pragma mark - Network stuff

- (void)performRequestForURL:(NSString *)urlAddition andCallback:(void (^)(NSDictionary *returnDictionary, NSError *error))block
{
    if (urlAddition == nil || [urlAddition length] == 0) {
        block([NSDictionary dictionary], [NSError errorWithDomain:@"DribbbleAPI Error" code:0 userInfo:@{@"Description": @"urlAdditionString empty"}]);
        return;
    }
    
    NSString *urlString = [baseURLString stringByAppendingString:urlAddition];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.0];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            block([NSDictionary dictionary], error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
            if (jsonString.length == 0) {
                block([NSDictionary dictionary], [NSError errorWithDomain:@"DribbbleAPI Error" code:1 userInfo:@{@"Description": @"jsonString empty"}]);
            } else {
                NSDictionary *jsonDictionary = [jsonString objectFromJSONString];
                block(jsonDictionary, nil);
            }
        }
    }];
    
    [task resume];
}

@end
