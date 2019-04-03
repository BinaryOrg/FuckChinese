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
#import <QMUIKit/QMUIKit.h>

#import "PersonDuanziController.h"
#import "MHLGraphTextViewController.h"
#import "MHLVideoTextViewController.h"

@interface ZDDThridController ()
<
UITableViewDelegate,
UITableViewDataSource,
QMUIAlbumViewControllerDelegate,
QMUIImagePickerViewControllerDelegate
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
                    @"的😊动态",
                    @"的👍视频",
                    @"的👍图文"
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -STATUSBARHEIGHT, SCREENWIDTH, SCREENHEIGHT + STATUSBARHEIGHT) style:UITableViewStyleGrouped];
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
            return self.titles.count;
        }else {
            return 1;
        }
    }else {
        if (!section) {
            return 1;
        }else {
            return self.titles.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        YMHLPeronHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"header_cell"];
        if (!cell) {
            cell = [[YMHLPeronHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header_cell"];
        }
        
        if ([GODUserTool isLogin] && !self.type) {
            [cell.bgImageView yy_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
            [cell.avatarImageView yy_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholder:[UIImage imageNamed:@"bg"] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive) completion:nil];
            cell.nickLabel.text = self.user.user_name;
            cell.dateLabel.text = [NSString stringWithFormat:@"Join in %@", [self formatFromTS:self.user.create_date]];
            cell.loginButton.alpha = 0;
            cell.nickLabel.alpha = 1;
            cell.dateLabel.alpha = 1;
            
        }else if (self.type) {
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
        if (!self.type) {
            [cell.avatarButton addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
            [cell.nickButton addTarget:self action:@selector(nickClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)avatarClick {
    [self presentAlbumViewControllerWithTitle:@"请选择头像"];
}

- (void)presentAlbumViewControllerWithTitle:(NSString *)title {
    
    // 创建一个 QMUIAlbumViewController 实例用于呈现相簿列表
    QMUIAlbumViewController *albumViewController = [[QMUIAlbumViewController alloc] init];
    albumViewController.albumViewControllerDelegate = self;
    albumViewController.contentType = QMUIAlbumContentTypeOnlyPhoto;
    albumViewController.title = title;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumViewController];
    
    // 获取最近发送图片时使用过的相簿，如果有则直接进入该相簿
    [albumViewController pickLastAlbumGroupDirectlyIfCan];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (QMUIImagePickerViewController *)imagePickerViewControllerForAlbumViewController:(QMUIAlbumViewController *)albumViewController {
    QMUIImagePickerViewController *imagePickerViewController = [[QMUIImagePickerViewController alloc] init];
    imagePickerViewController.imagePickerViewControllerDelegate = self;
    imagePickerViewController.maximumSelectImageCount = 1;
    imagePickerViewController.allowsMultipleSelection = NO;
    return imagePickerViewController;
}

#pragma mark - <QMUIImagePickerViewControllerDelegate>

- (void)imagePickerViewController:(QMUIImagePickerViewController *)imagePickerViewController didSelectImageWithImagesAsset:(QMUIAsset *)imageAsset afterImagePickerPreviewViewControllerUpdate:(QMUIImagePickerPreviewViewController *)imagePickerPreviewViewController {
    [imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLoadingWithText:@"上传图片..."];
    });
    [MFNETWROK upload:@"http://120.78.124.36:10010/MRYX/User/ChangeUserAvatar" params:@{@"userId": [GODUserTool shared].user.user_id} name:@"pictures" images:@[imageAsset.previewImage] imageScale:0.1 imageType:MFImageTypePNG progress:nil success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        if ([result[@"resultCode"] isEqualToString:@"0"]) {
            GODUserModel *user = [GODUserModel yy_modelWithJSON:result[@"user"]];
            [GODUserTool shared].user = user;
            self.user = user;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopLoading];
                [self.tableView reloadData];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorWithText:@"上传失败！"];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self stopLoading];
            });
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showErrorWithText:@"上传失败！"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopLoading];
        });
    }];
    //    [imageAsset requestImageData:^(NSData *imageData, NSDictionary<NSString *,id> *info, BOOL isGIF, BOOL isHEIC) {
    //        [MFNETWROK upload:@"User/ChangeUserAvater"
    //                   params:@{
    //                            @"userId": [ZDDUserTool shared].user.user_id
    //                            }
    //                     name:@"pictures"
    //               imageDatas:@[imageData]
    //                 progress:nil
    //                  success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
    //                      NSLog(@"%@", result);
    //                      if ([result[@"resultCode"] isEqualToString:@"0"]) {
    //                          ZDDUserModel *user = [ZDDUserModel yy_modelWithJSON:result[@"user"]];
    //                          [ZDDUserTool shared].user = user;
    //                          dispatch_async(dispatch_get_main_queue(), ^{
    //                              [self stopLoading];
    //                              [self reloadCustomInfo];
    //                          });
    //                      }else {
    //                          dispatch_async(dispatch_get_main_queue(), ^{
    //                              [self showErrorWithText:@"上传失败！"];
    //                          });
    //                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                              [self stopLoading];
    //                          });
    //                      }
    //                  }
    //                  failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        [self showErrorWithText:@"上传失败！"];
    //                    });
    //                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                        [self stopLoading];
    //                    });
    //                  }];
    //    }];
}

- (void)startLoadingWithText:(NSString *)text {
    //    [QMUITips showLoading:text inView:self.view];
    //    [self.tips showLoading:text];
    [MFHUDManager showLoading:text];
}

- (void)showErrorWithText:(NSString *)text {
    //    [self.tips showError:text];
    [MFHUDManager showError:text];
}

- (void)showSuccessWithText:(NSString *)text {
    //    [self.tips showSucceed:text];
    [MFHUDManager showSuccess:text];
    
}

- (void)stopLoading {
    //    [QMUITips hideAllToastInView:self.view animated:YES];
    //    [self.tips hideAnimated:YES];
    [MFHUDManager dismiss];
}

- (void)nickClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入用户昵称" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户昵称";
    }];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/User/ChangeUserInfo"
                 params:@{
                          @"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"",
                          @"gender": @"m",
                          @"userName": alert.textFields[0].text
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    
                    if ([result[@"resultCode"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD dismiss];
                        });
                        GODUserModel *userModel = [GODUserModel yy_modelWithJSON:result[@"user"]];
                        // 存储用户信息
                        [GODUserTool shared].user = userModel;
                        self.user = userModel;
                        [self.tableView reloadData];
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showErrorWithStatus:@"修改失败"];
                        });
                    }
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:@"修改失败"];
                    });
                }];
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [self presentViewController:alert animated:YES completion:nil];
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
            if ([GODUserTool isLogin]) {
                PersonDuanziController *duanzi = [[PersonDuanziController alloc] init];
                duanzi.user_id = self.type ? self.user_id : self.user.user_id;
                [self.navigationController pushViewController:duanzi animated:YES];
            }else {
                [self login];
            }
        }else if (indexPath.row == 1) {
            if ([GODUserTool isLogin]) {
                MHLVideoTextViewController *v = [MHLVideoTextViewController new];
                v.user_id = self.type ? self.user_id : self.user.user_id;
                [self.navigationController pushViewController:v animated:YES];
            }else {
                [self login];
            }
        }else {
            if ([GODUserTool isLogin]) {
                MHLGraphTextViewController *v = [MHLGraphTextViewController new];
                v.user_id = self.type ? self.user_id : self.user.user_id;
                [self.navigationController pushViewController:v animated:YES];
            }else {
                [self login];
            }
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
