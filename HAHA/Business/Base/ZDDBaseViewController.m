//
//  ZDDBaseViewController.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDBaseViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "UINavigationController+FDFullscreenPopGesture.h"

#import "ZDDRetryView.h"


@interface ZDDBaseViewController ()

@property (nonatomic, strong) ASTableNode *tableNode;
@property (nonatomic, strong) ZDDRetryView *emptyView;
@property (nonatomic, strong) UIView *hlEmptyView;
@end

@implementation ZDDBaseViewController

- (UIView *)hlEmptyView {
    if (!_hlEmptyView) {
        _hlEmptyView = [[UIView alloc] initWithFrame:self.view.bounds];
        _hlEmptyView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        imageView.image = [UIImage imageNamed:@"empty_icon_150x150_"];
        imageView.center = CGPointMake(SCREENWIDTH/2, (SCREENHEIGHT-STATUSBARANDNAVIGATIONBARHEIGHT)/2);
        [_hlEmptyView addSubview:imageView];
    }
    return _hlEmptyView;
}

- (void)addEmptyView {
    [self.view addSubview:self.hlEmptyView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)addTableNode {
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.backgroundColor = [UIColor whiteColor];
    _tableNode.view.estimatedRowHeight = 0;
    _tableNode.leadingScreensForBatching = 1.0;
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:_tableNode.view];
    
    CGFloat bottomH = SafeAreaBottomHeight;
    if (self.navigationController.childViewControllers.firstObject == self) {
        bottomH = SafeTabBarHeight;
    }
    [_tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomH);
    }];
    
    
}

- (void)headerRefresh {
    
    
}

- (void)footerRefresh {
    
    
}

- (void)endHeaderRefresh {
    [self.tableNode.view.mj_header endRefreshing];
}

- (void)endFooterRefresh {
    [self.tableNode.view.mj_footer endRefreshing];
}

- (void)setHiddenNavBar:(BOOL)hiddenNavBar {
    self.fd_prefersNavigationBarHidden = hiddenNavBar;
}

- (void)setShowRefrehHeader:(BOOL)showRefrehHeader {
    if (self.tableNode) {
      
        if (showRefrehHeader) {
            __weak typeof(self) weakSelf = self;
            
            MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                [weakSelf headerRefresh];
            }];
            
//            NSMutableArray *idleImages = [NSMutableArray array];
//            for (NSUInteger i = 1; i <= 19; i++) {
//                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"HAO-%@", @(i)]];
//                [idleImages addObject:image];
//            }
//            
//            [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
//            
//            // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//            NSMutableArray *refreshingImages = [NSMutableArray array];
//            for (NSUInteger i = 4; i <= 19; i++) {
//                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"HAO-%@", @(i)]];
//                [refreshingImages addObject:image];
//            }
//            [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
//            
//            // 设置正在刷新状态的动画图片
//            [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
//            
//            //隐藏时间
//            gifHeader.lastUpdatedTimeLabel.hidden = YES;
//            //隐藏状态
//            gifHeader.stateLabel.hidden = YES;
            
            
            _tableNode.view.mj_header = gifHeader;
        }else {
            _tableNode.view.mj_header = nil;

        }
      
    }
}

- (void)setShowRefrehFooter:(BOOL)showRefrehFooter {
    if (self.tableNode) {
        if (showRefrehFooter) {
            __weak typeof(self) weakSelf = self;
            MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
                [weakSelf footerRefresh];
            }];
            _tableNode.view.mj_footer = footer;
        }else {
            _tableNode.view.mj_footer = nil;
        }
    }
    
}

- (void)setNoMoreData {
    if (self.tableNode) {
        [self.tableNode.view.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)resetFooter {
    if (self.tableNode) {
        [self.tableNode.view.mj_footer resetNoMoreData];
    }
}

- (void)showEmptyView {
    [self.view addSubview:self.emptyView];
    [self.view bringSubviewToFront:self.emptyView];
}

- (void)hideEmptyView {
    [self.emptyView removeFromSuperview];
}

- (ZDDRetryView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[ZDDRetryView alloc] initWithFrame:CGRectMake(0, -TabBarHeight, ScreenWidth, ScreenHeight)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self)weakSelf = self;
        _emptyView.block = ^{
            [weakSelf headerRefresh];
        };
    }
    return _emptyView;
}

@end
