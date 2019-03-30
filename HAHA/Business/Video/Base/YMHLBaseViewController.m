//
//  YMHLBaseViewController.m
//  HAHA
//
//  Created by ZDD on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLBaseViewController.h"

@interface YMHLBaseViewController ()
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIView *netErrorView;

@end

@implementation YMHLBaseViewController

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
        _emptyView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        imageView.image = [UIImage imageNamed:@"empty_icon_150x150_"];
        imageView.center = CGPointMake(SCREENWIDTH/2, (SCREENHEIGHT-STATUSBARANDNAVIGATIONBARHEIGHT)/2);
        [_emptyView addSubview:imageView];
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = _emptyView.bounds;
        [b addTarget:self action:@selector(errorClick) forControlEvents:UIControlEventTouchUpInside];
        [_emptyView addSubview:b];
    }
    return _emptyView;
}

- (UIView *)netErrorView {
    if (!_netErrorView) {
        _netErrorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _netErrorView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        imageView.image = [UIImage imageNamed:@"nonetwork_151x150_"];
        imageView.center = CGPointMake(SCREENWIDTH/2, (SCREENHEIGHT-STATUSBARANDNAVIGATIONBARHEIGHT)/2);
        [_netErrorView addSubview:imageView];
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = _netErrorView.bounds;
        [b addTarget:self action:@selector(errorClick) forControlEvents:UIControlEventTouchUpInside];
        [_netErrorView addSubview:b];
    }
    return _netErrorView;
}

- (void)errorClick {
    if (self.errorViewClickBlock) {
        self.errorViewClickBlock();
    }
}

- (void)addEmptyView {
    [self.view addSubview:self.emptyView];
}
- (void)addNetworkErrorView {
    [self.view addSubview:self.netErrorView];
}

- (void)removeErrorView {
    [self.emptyView removeFromSuperview];
    [self.netErrorView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
