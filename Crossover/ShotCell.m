//
//  ShotCell.m
//  Example Project
//
//  Created by Alexander Blunck on 27/10/13.
//  Copyright (c) 2013 Alexander Blunck. All rights reserved.
//

#import "ShotCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DribbbleShot.h"

@implementation ShotCell

#pragma mark - Accessors
-(void) setShot:(DribbbleShot *)shot
{
    _shot = shot;
    
    [_shotImageView setImageWithURL:_shot.imageURL];
}

@end
