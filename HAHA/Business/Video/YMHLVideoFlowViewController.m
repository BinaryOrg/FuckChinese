//
//  YMHLVideoFlowViewController.m
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "YMHLVideoFlowViewController.h"
#import "YMHLVideoflowLayout.h"
#import "YMHLVideoCollectionViewCell.h"
#import <YYCategories/YYCategories.h>
#import "YMHLVideoModel.h"
#import <YYModel/NSObject+YYModel.h>

@interface YMHLVideoFlowViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) UIView *refreshView;
@end

@implementation YMHLVideoFlowViewController

- (UIView *)refreshView {
    if (!_refreshView) {
        _refreshView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, SCREENHEIGHT - STATUSBARANDNAVIGATIONBARHEIGHT - 60 - TABBARHEIGHT, 40, 40)];
        _refreshView.layer.cornerRadius = 15;
        _refreshView.layer.masksToBounds = YES;
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = _refreshView.bounds;
        [b setImage:[UIImage imageNamed:@"icon_main_refresh_active"] forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"icon_main_refresh_active"] forState:UIControlStateHighlighted];
        [b addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        [_refreshView addSubview:b];
        _refreshView.backgroundColor = [UIColor whiteColor];
    }
    return _refreshView;
}

- (void)rotateView:(UIView *)view {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
    rotationAnimation.duration = 0.5;
    rotationAnimation.repeatCount = HUGE_VALF;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRatateWithView:(UIView *)view {
    [view.layer removeAllAnimations];
}

- (void)refresh:(UIButton *)sender {
    [self rotateView:sender];
    sender.userInteractionEnabled = NO;
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Duanzi/ListRecommendDuanzi"
             params:@{
                      @"userId": @"",
                      @"category": @"video"
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    sender.userInteractionEnabled = YES;
                    [self stopRatateWithView:sender];
                });
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    NSMutableArray *inserts = @[].mutableCopy;
                    for (NSDictionary *dic in result[@"data"]) {
                        YMHLVideoModel *video = [YMHLVideoModel yy_modelWithJSON:dic];
                        if (video) {
                            [inserts addObject:video];
                        }
                    }
                    [self.list insertObjects:inserts atIndex:0];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MFHUDManager showSuccess:@"为您推荐200条新鲜视频～"];
                        [self.collectionView reloadData];
                        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sender.userInteractionEnabled = YES;
                        [MFHUDManager showError:@"刷新失败，请检查网络"];
                    });
                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopRatateWithView:sender];
                    sender.userInteractionEnabled = YES;
                    [MFHUDManager showError:@"刷新失败，请检查网络"];
                });
            }];
}

- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        YMHLVideoflowLayout *layout = [[YMHLVideoflowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - STATUSBARANDNAVIGATIONBARHEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YMHLVideoCollectionViewCell class] forCellWithReuseIdentifier:@"video_cell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.prefetchingEnabled = NO;
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavi];
    __weak __typeof(self)weakSelf = self;
    self.errorViewClickBlock = ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf sendRequest];
    };
    [self sendRequest];
}

- (void)setNavi {
    self.navigationItem.title = @"视频圈";
}

- (void)sendRequest {
    [self removeErrorView];
    [SVProgressHUD show];
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Duanzi/ListRecommendDuanzi"
             params:@{
                      @"userId": @"",
                      @"category": @"video"
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    [self.list removeAllObjects];
                    for (NSDictionary *dic in result[@"data"]) {
                        YMHLVideoModel *video = [YMHLVideoModel yy_modelWithJSON:dic];
                        if (video) {
                            [self.list addObject:video];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self removeErrorView];
                        [self.view addSubview:self.collectionView];
                        [self.view addSubview:self.refreshView];
                        [self.collectionView reloadData];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addNetworkErrorView];
                    });
                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self addNetworkErrorView];
                });
            }];
    
    
}

#pragma mark - UICollectionViewDataSources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.list.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YMHLVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_cell" forIndexPath:indexPath];
    YMHLVideoModel *videoModel = self.list[indexPath.row];
    [cell.coverImageView yy_setImageWithURL:[NSURL URLWithString:videoModel.picture_path] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive)];
    
    cell.contentLabel.text = videoModel.content;
    [cell.imgButton setSelected:videoModel.is_star];
    [cell.avatar yy_setImageWithURL:[NSURL URLWithString:videoModel.user.avatar] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive)];
    [cell.imgButton addTarget:self action:@selector(handleCollectionEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickLabel.text = videoModel.user.user_name;
    return cell;
}

- (void)handleCollectionEvent:(TTAnimationButton *)sender {
    YMHLVideoCollectionViewCell *cell = (YMHLVideoCollectionViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    YMHLVideoModel *videoModel = self.list[indexPath.row];
    videoModel.is_star = !videoModel.is_star;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
}

- (CGFloat)heightFromWidth:(CGFloat)width atIndex:(NSInteger)index {
    NSInteger i = index%5;
    if (!i) {
        return width*3/2;
    }else if (i == 1) {
        return width*2;
    }else if (i == 2) {
        return width*5/4;
    }else if (i == 3) {
        return width*6/5;
    }else if (i == 4) {
        return width*7/6;
    }
    return 0;
}

#pragma mark - UICollectionView delegate flowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (SCREENWIDTH-30)/2;
    CGFloat height = [self heightFromWidth:width atIndex:indexPath.row];
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGFloat margin = 10;
    UIEdgeInsets edgeInsets = {margin,margin,margin,margin};
    return edgeInsets;
}

#pragma mark - YMHLFlowLayout
//返回每个cell的高度
//- (CGFloat)waterflowLayout:(XMGWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
//{
//    XMGShop *shop = self.shops[index];
//    return itemWidth * shop.h / shop.w;
//}

//- (CGFloat)videoflowLayout:(YMHLVideoFlowLayout *)videoflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
//    NSInteger i = index%2;
//    if (!i) {
//        return itemWidth*3/2;
//    }else {
//        return itemWidth*2;
//    }
//}
//
////每行的最小距离
//- (CGFloat)rowMarginInVideoflowLayout:(YMHLVideoFlowLayout *)videoflowLayout
//{
//    return 10;
//}
////有多少列
//- (CGFloat)columnCountInVideoflowLayout:(YMHLVideoFlowLayout *)videoflowLayout
//{
//    return 2;
//}
//
////内边距
//- (UIEdgeInsets)edgeInsetsInVideoflowLayout:(YMHLVideoFlowLayout *)videoflowLayout
//{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

@end
