//
//  CCPopularShotsViewController.m
//  Crossover
//
//  Created by Cornelius Carl on 05.01.14.
//  Copyright (c) 2014 Cornelius Carl. All rights reserved.
//

#import "CCPopularShotsViewController.h"

#import "CCDribbbleAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImagePrefetcher.h>

#import "DribbbleShot.h"

#import "ShotCell.h"

#import "CCImageCollectionViewCell.h"

@interface CCPopularShotsViewController ()
{
    NSArray *dataArray;
}
@end

@implementation CCPopularShotsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Popular", @"Popular");
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:0];
    self.tabBarItem = tabBarItem;
    
    [self.collectionView registerClass:[CCImageCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"ShotCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    [flowLayout setItemSize:CGSizeMake(320, 240)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.collectionViewLayout = flowLayout;
    
    [[CCDribbbleAPI sharedAPI] getShotsForList:DribbbleListTypePopular withCompletionBlock:^(NSArray *shotsArray) {
        //TODO error
        if (shotsArray) {
            dataArray = shotsArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
//                [self prefetchImagesForCollectionView:self.collectionView];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (dataArray) {
        return dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CCImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    if (!cell) {
//        cell = [[CCImageCollectionViewCell alloc] init];
//    }
    DribbbleShot *shot = dataArray[indexPath.row];
    cell.shot = shot;
//    if (shot.image) {
//        cell.imageView.image = shot.image;
//    } else {
//        [cell.imageView setImageWithURL:shot.imageURL placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            shot.image = image;
//        }];
//    }
//    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    progressView.frame = CGRectMake(0, 240-2, 320, 2);
//    progressView.progress = 0;
//    [cell.contentView addSubview:progressView];

//    [cell.imageView setImageWithURL:shot.imageURL placeholderImage:nil options:SDWebImageCacheMemoryOnly | SDWebImageContinueInBackground progress:^(NSUInteger receivedSize, long long expectedSize) {
//        progressView.progress = receivedSize/expectedSize;
//        progressView.progress = 0.5;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        NSLog(@"%@", error);
//        [progressView removeFromSuperview];
//    }];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 240);
}

#pragma mark - UIScrollViewDelegate;

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self prefetchImagesForCollectionView:self.collectionView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (!decelerate) {
//        [self prefetchImagesForCollectionView:self.collectionView];
//    }
//}

#pragma mark - Prefetch


- (void)prefetchImagesForCollectionView:(UICollectionView *)collectionView
{
    NSArray *indexPaths = [collectionView indexPathsForVisibleItems];
    if (indexPaths.count == 0) {
        return;
    }
    
    NSIndexPath *minimumIndexPath = [indexPaths firstObject];
    NSIndexPath *maximumIndexPath = [indexPaths lastObject];
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        if (indexPath.section < minimumIndexPath.section || (indexPath.section == minimumIndexPath.section && indexPath.row < minimumIndexPath.row)) minimumIndexPath = indexPath;
        if (indexPath.section > maximumIndexPath.section || (indexPath.section == maximumIndexPath.section && indexPath.row > maximumIndexPath.row)) maximumIndexPath = indexPath;
    }
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    indexPaths = [self collectionView:collectionView priorIndexPathCount:5 fromIndexPath:minimumIndexPath];
    for (NSIndexPath *indexPath in indexPaths)
        [imageURLs addObject:[dataArray[indexPath.row] imageURL]];
    indexPaths = [self collectionView:collectionView nextIndexPathCount:5 fromIndexPath:maximumIndexPath];
    for (NSIndexPath *indexPath in indexPaths)
        [imageURLs addObject:[dataArray[indexPath.row] imageURL]];
    
    // now prefetch
    
    if ([imageURLs count] > 0)
    {
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:imageURLs];
    }
}

- (NSArray *)collectionView:(UICollectionView *)collectionView priorIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    for (NSInteger i = 0; i < count; i++) {
        if (row == 0) {
            if (section == 0) {
                return indexPaths;
            } else {
                section--;
                row = [collectionView numberOfItemsInSection:section] - 1;
            }
        } else {
            row--;
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return indexPaths;
}

/** Retrieve NSIndexPath for a certain number of following particular NSIndexPath in the table view.
 *
 * @param  tableView  The tableview for which we're going to retrieve indexPaths.
 * @param  count      The number of rows to retrieve
 * @param  indexPath  The indexPath where we're going to start (presumably the last visible indexPath)
 *
 * @return            An array of indexPaths.
 */

- (NSArray *)collectionView:(UICollectionView *)collectionView nextIndexPathCount:(NSInteger)count fromIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSInteger rowCountForSection = [collectionView numberOfItemsInSection:section];
    
    for (NSInteger i = 0; i < count; i++) {
        row++;
        if (row == rowCountForSection) {
            row = 0;
            section++;
            if (section == [collectionView numberOfSections]) {
                return indexPaths;
            }
            rowCountForSection = [collectionView numberOfItemsInSection:section];
        }
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    
    return indexPaths;
}

@end
