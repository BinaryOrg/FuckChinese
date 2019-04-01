//
//  ZDDThridController.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDThridController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "YMHLPeronHeaderTableViewCell.h"
#import "ZDDLogInController.h"

@interface ZDDThridController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GODUserModel *user;
@end

@implementation ZDDThridController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    if (self.type) {
        [self sendRequest];
        __weak __typeof(self)weakSelf = self;
        self.bottomErrorViewClickBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf sendRequest];
        };
    }else {
        self.user = [GODUserTool shared].user;
        [self.view addSubview:self.tableView];
    }
    
}

//获取用户信息
- (void)sendRequest {
    [MFNETWROK post:@""
             params:@{}
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    self.user = [GODUserModel yy_modelWithJSON:result[@"data"]];
                    [self.view addSubview:self.tableView];
                }else {
                    [self addNetworkErrorView];
                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                [self addNetworkErrorView];
            }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    if (!self.type) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.type) {
        if (!section) {
            return 1;
        }else if (section == 1) {
            return 3;
        }else {
            return 1;
        }
    }else {
        if (!section) {
            return 1;
        }else {
            return 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        YMHLPeronHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header_cell"];
        if (!cell) {
            cell = [[YMHLPeronHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header_cell"];
        }
        [cell.bgImageView yy_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
        [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
        if ([GODUserTool isLogin] || self.type) {
            cell.nickLabel.text = self.user.user_name;
            cell.dateLabel.text = [NSString stringWithFormat:@"Join in %@", [self formatFromTS:self.user.create_date]];
            cell.loginButton.alpha = 0;
            cell.nickLabel.alpha = 1;
            cell.dateLabel.alpha = 1;
        }else {
            cell.nickLabel.alpha = 0;
            cell.dateLabel.alpha = 0;
            cell.loginButton.alpha = 1;
            [cell.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    return nil;
}

- (void)login {
    ZDDLogInController *vc = [ZDDLogInController new];
    [self.navigationController presentViewController:vc animated:YES completion:nil] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 300;
    }else {
        return 44;
    }
}

- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}

@end
