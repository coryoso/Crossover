//
//  CCImageCollectionViewCell.h
//  Crossover
//
//  Created by Cornelius Carl on 05.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DribbbleShot;

@interface CCImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) DribbbleShot *shot;

@end
