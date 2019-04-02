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
#import "YMHLSecondTableViewCell.h"
#import "YMHLPersonLogoutTableViewCell.h"

@interface ZDDThridController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GODUserModel *user;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@end

@implementation ZDDThridController

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[
                    @"的动态",
                    @"的点赞"
                    ];
    }
    return _titles;
}

- (NSArray *)images {
    if (!_images) {
        _images = @[
                    @"",
                    @""
                    ];
    }
    return _images;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload0) name:@"reloadTTT" object:nil];
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

- (void)reload0 {
    [self.tableView reloadData];
}



//获取用户信息
- (void)sendRequest {
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/User/GetUserInfoByUserId"
             params:@{
                      @"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"",
                      @"targetUserId": self.type ? self.user_id : [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @""
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    self.user = [GODUserModel yy_modelWithJSON:result[@"user"]];
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
//    return 1;
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
            return 2;
        }else {
            return 1;
        }
    }else {
        if (!section) {
            return 1;
        }else {
            return 2;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        YMHLPeronHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header_cell"];
        if (!cell) {
            cell = [[YMHLPeronHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header_cell"];
        }
        
        if ([GODUserTool isLogin] || self.type) {
            [cell.bgImageView yy_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
            cell.nickLabel.text = self.user.user_name;
            cell.dateLabel.text = [NSString stringWithFormat:@"Join in %@", [self formatFromTS:self.user.create_date]];
            cell.loginButton.alpha = 0;
            cell.nickLabel.alpha = 1;
            cell.dateLabel.alpha = 1;
        }else {
            cell.bgImageView.image = [UIImage imageNamed:@"bg"];
            cell.avatarImageView.image = [UIImage imageNamed:@"bg"];
            cell.nickLabel.alpha = 0;
            cell.dateLabel.alpha = 0;
            cell.loginButton.alpha = 1;
            [cell.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }else if (indexPath.section == 1) {
        YMHLSecondTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"sec_cell"];
        if (!cell) {
            cell = [[YMHLSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sec_cell"];
        }
        if (self.type) {
            cell.nameLabel.text = [NSString stringWithFormat:@"她%@", self.titles[indexPath.row]];
        }else {
            cell.nameLabel.text = [NSString stringWithFormat:@"我%@", self.titles[indexPath.row]];
        }
        
        return cell;
    }else {
        YMHLPersonLogoutTableViewCell *logout = [tableView dequeueReusableCellWithIdentifier:@"logout_cell"];
        if (!logout) {
            logout = [[YMHLPersonLogoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logout_cell"];
        }
        return logout;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if ([GODUserTool isLogin]) {
            [[GODUserTool shared] clearUserInfo];
            [self.tableView reloadData];
        }
    }else if (indexPath.section == 1) {
        if (!indexPath.row) {
            
        }else {
            
        }
    }
}

- (void)login {
    ZDDLogInController *vc = [ZDDLogInController new];
    [self.navigationController presentViewController:vc animated:YES completion:nil] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 300;
    }else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!section) {
        return CGFLOAT_MIN;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSString *)formatFromTS:(NSInteger)ts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSString *str = [NSString stringWithFormat:@"%@",
                     [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]]];
    return str;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
