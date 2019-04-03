//
//  MHLVideoTextViewController.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/3.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "MHLVideoTextViewController.h"
#import "YMHLVideoflowLayout.h"
#import "YMHLVideoCollectionViewCell.h"
#import <YYCategories/YYCategories.h>
#import "YMHLVideoModel.h"
#import <YYModel/NSObject+YYModel.h>
#import "YMHLVideoDetailViewController.h"
@interface MHLVideoTextViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation MHLVideoTextViewController

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

    [self sendRequest];
}

- (void)setNavi {
    self.navigationItem.title = @"👍";
}

- (void)sendRequest {
    [SVProgressHUD show];
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Duanzi/ListStaredDuanziByUserId"
             params:@{
                      @"userId": self.user_id ?:@"",
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    [self.list removeAllObjects];
                    for (NSDictionary *dic in result[@"data"][@"video_text"]) {
                        YMHLVideoModel *video = [YMHLVideoModel yy_modelWithJSON:dic];
                        if (video) {
                            [self.list addObject:video];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.list.count) {
                            [self.view addSubview:self.collectionView];
                            [self.collectionView reloadData];
                        }else {
                            [self addEmptyView];
                        }
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self addEmptyView];
                    });
                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self addEmptyView];
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
    [cell.coverImageView yy_setImageWithURL:[NSURL URLWithString:videoModel.picture_path] placeholder:nil options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
    
    cell.contentLabel.text = videoModel.content;
    [cell.imgButton setSelected:videoModel.is_star];
    [cell.avatar yy_setImageWithURL:[NSURL URLWithString:videoModel.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
    [cell.imgButton addTarget:self action:@selector(handleCollectionEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickLabel.text = videoModel.user.user_name;
    return cell;
}

- (void)handleCollectionEvent:(TTAnimationButton *)sender {
    if ([GODUserTool isLogin]) {
        YMHLVideoCollectionViewCell *cell = (YMHLVideoCollectionViewCell *)sender.superview.superview.superview;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        YMHLVideoModel *videoModel = self.list[indexPath.row];
        videoModel.is_star = !videoModel.is_star;
        [self star:videoModel.id];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }else {
        ZDDLogInController *vc = [ZDDLogInController new];
        [self.navigationController presentViewController:vc animated:YES completion:nil] ;
    }
}

- (void)star:(NSString *)targetId {
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Star/AddOrCancel"
             params:@{
                      @"userId": [GODUserTool isLogin] ? [GODUserTool shared].user.user_id : @"",
                      @"targetId": targetId
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                
            }];
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([GODUserTool isLogin]) {
        YMHLVideoModel *videoModel = self.list[indexPath.row];
        YMHLVideoDetailViewController *detail = [[YMHLVideoDetailViewController alloc] init];
        detail.videoModel = videoModel;
        [self.navigationController pushViewController:detail animated:YES];
    }else {
        ZDDLogInController *vc = [ZDDLogInController new];
        [self.navigationController presentViewController:vc animated:YES completion:nil] ;
    }
}

@end
