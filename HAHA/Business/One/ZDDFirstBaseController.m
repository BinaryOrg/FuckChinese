//
//  ZDDFirstBaseController.m
//  HAHA
//
//  Created by Maker on 2019/4/12.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDFirstBaseController.h"
#import <GLYPageView.h>
#import "YMHLVideoFlowViewController.h"
#import "ZDDFirstController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface ZDDFirstBaseController ()<GLYPageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) GLYPageView *pageView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) ZDDFirstController *firstVC;
@property (nonatomic, strong) YMHLVideoFlowViewController *secondVC;

@end

@implementation ZDDFirstBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}


- (void)setupUI {
    
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.firstVC.view];
    self.firstVC.view.frame = CGRectMake(0, 0, ScreenWidth, self.scrollView.height);
    
    [self.scrollView addSubview:self.secondVC.view];
    self.secondVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.height);
    
}

- (void)pageViewSelectdIndex:(NSInteger)index {
    
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.pageView externalScrollView:scrollView totalPage:2 startOffsetX:0];
    
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(0, StatusBarHeight + 44, ScreenWidth, ScreenHeight - SafeTabBarHeight - StatusBarHeight - 44);
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight - SafeTabBarHeight - StatusBarHeight - 44);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (GLYPageView *)pageView {
    if (!_pageView) {
        _pageView = [[GLYPageView alloc] initWithFrame:CGRectMake(0.f, StatusBarHeight, ScreenWidth, 44.f) titlesArray:@[@"图文",@"视频"]];
        _pageView.delegate = self;
        _pageView.titleFont = [UIFont fontWithName:@"KohinoorDevanagari-Semibold" size:18];
        _pageView.selectTitleColor = [UIColor blackColor];
        _pageView.scrollViewBackgroundColor = [UIColor clearColor];
        _pageView.titleColor = color(137, 137, 137, 1);
        _pageView.backgroundColor = [UIColor clearColor];
        _pageView.lineBackgroundColor = [UIColor grayColor];
        [_pageView initalUI];
    }
    return _pageView;
}

- (ZDDFirstController *)firstVC {
    if (!_firstVC) {
        _firstVC = [ZDDFirstController new];
        [self addChildViewController:_firstVC];
    }
    return _firstVC;
}

- (YMHLVideoFlowViewController *)secondVC {
    if (!_secondVC) {
        _secondVC = [YMHLVideoFlowViewController new];
        [self addChildViewController:_secondVC];
    }
    return _secondVC;
}


@end
