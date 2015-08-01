//
//  CCImageCollectionViewCell.m
//  Crossover
//
//  Created by Cornelius Carl on 05.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import "CCImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DribbbleShot.h"

@interface CCImageCollectionViewCell ()
@property (weak) id <SDWebImageOperation> imageOperation;
@end

@implementation CCImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareForReuse
{
    [super prepareForReuse];
 
    NSLog(@"called");
    
//    [_imageView cancelCurrentArrayLoad];
    [_imageView setImage:nil];
    
    if (self.imageOperation)
        [self.imageOperation cancel];
    
    self.imageOperation = nil;
}

-(void) setShot:(DribbbleShot *)shot
{
    _shot = shot;
    
    [_imageView setImageWithURL:_shot.imageURL];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    self.imageOperation = [manager downloadWithURL:_shot.imageURL
                                           options:SDWebImageRetryFailed
                                          progress:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                             if (image)
                                                 self.imageView.image = image;
                                         }];
}

@end
