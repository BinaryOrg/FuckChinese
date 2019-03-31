//
//  YMHLVideoDetailViewController.m
//  HAHA
//
//  Created by ZDD on 2019/3/31.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLVideoDetailViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ZDDCommentModel.h"
#import "YMHLCommentTableViewCell.h"
#import "YMHLSubcommentTableViewCell.h"

@interface YMHLVideoDetailViewController ()
<
SuperPlayerDelegate,
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) SuperPlayerView *playerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZDDCommentModel *> *list;
@end

@implementation YMHLVideoDetailViewController
- (NSMutableArray *)list {
    if (!_list) {
        _list = @[].mutableCopy;
    }
    return _list;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(self.holderView), SCREENWIDTH, SCREENHEIGHT - HEIGHT(self.holderView)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SuperPlayerView alloc] init];
        // 设置代理，用于接受事件
        _playerView.delegate = self;
        // 设置父View，_playerView会被自动添加到holderView下面
        _playerView.fatherView = self.holderView;
    }
    return _playerView;
}

- (UIView *)holderView {
    if (!_holderView) {
        _holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*3/4)];
        _holderView.backgroundColor = [UIColor whiteColor];
        
    }
    return _holderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.holderView];
//    self.fd_prefersNavigationBarHidden = YES;
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = self.videoModel.video;
    [self.playerView.coverImageView yy_setImageWithURL:[NSURL URLWithString:self.videoModel.picture_path] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive)];
    // 开始播放
    [self.playerView playWithModel:playerModel];
    SPDefaultControlView *controlView = (SPDefaultControlView *)self.playerView.controlView;
    ZDDThemeConfiguration *theme = [ZDDThemeConfiguration defaultConfiguration];
    [controlView.videoSlider setMinimumTrackTintColor:theme.themeColor];
    controlView.backBtn.hidden = YES;
    controlView.disableBackBtn = YES;
    [self sendRequest];
    __weak __typeof(self)weakSelf = self;
    self.bottomErrorViewClickBlock = ^{
        NSLog(@"123");
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf sendRequest];
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(comment)];
}

- (void)comment {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入评论内容" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入评论内容";
    }];__weak __typeof(self)weakSelf = self;
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD show];
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Comment/Create"
                 params:@{
                          @"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"",
                          @"targetId": strongSelf.videoModel.id,
                          @"content": alert.textFields[0].text
                          }
                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                    
                    if ([result[@"resultCode"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                        });
                        [strongSelf sendRequest];
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SVProgressHUD showErrorWithStatus:@"评论失败"];
                        });
                    }
                }
                failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showSuccessWithStatus:@"评论失败"];
                    });
                }];
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sendRequest {
    [self removeErrorView];
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Comment/ListCommentByTargetid"
             params:@{
                      @"targetId": self.videoModel.id
                      }
            success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
                if ([result[@"resultCode"] isEqualToString:@"0"]) {
                    [self.list removeAllObjects];
                    for (NSDictionary *dic in result[@"data"]) {
                        ZDDCommentModel *comment = [ZDDCommentModel yy_modelWithJSON:dic];
                        if (comment) {
                            [self.list addObject:comment];
                        }
                    }
                    if (self.list.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.view addSubview:self.tableView];
                            [self.tableView reloadData];
                        });
                    }else {
                        [self addBottomErrorView];
                    }
                }else {
                    [self addBottomErrorView];
                }
            }
            failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
                [self addBottomErrorView];
            }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list[section].subcomments.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDDCommentModel *comment = self.list[indexPath.section];
    if (!indexPath.row) {
        YMHLCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment_cell"];
        if (!cell) {
            cell = [[YMHLCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment_cell"];
        }
        
        [cell.avatar yy_setImageWithURL:[NSURL URLWithString:comment.user.avatar] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive)];
        cell.nickLabel.text = comment.user.user_name;
        cell.commentLabel.text = comment.content;
        [cell.commentLabel setQmui_height:comment.content_height];
        [cell.dateLabel setQmui_top:MaxY(cell.commentLabel)+5];
        [cell.commentButton setQmui_top:MaxY(cell.commentLabel)+5];
        [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        YMHLSubCommentsModel *subcomment = comment.subcomments[indexPath.row-1];
        YMHLSubcommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub_comment_cell"];
        if (!cell) {
            cell = [[YMHLSubcommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub_comment_cell"];
        }
        
        [cell.avatar yy_setImageWithURL:[NSURL URLWithString:subcomment.src_user.avatar] options:(YYWebImageOptionProgressiveBlur|YYWebImageOptionProgressive)];
        cell.src_nickLabel.text = subcomment.src_user.user_name;
        cell.tar_nickLabel.text = subcomment.tar_user.user_name;
        cell.commentLabel.text = subcomment.content;
        [cell.commentLabel setQmui_height:subcomment.content_height];
        [cell.dateLabel setQmui_top:MaxY(cell.commentLabel)+5];
        [cell.commentButton setQmui_top:MaxY(cell.commentLabel)+5];
        [cell.commentButton addTarget:self action:@selector(subcommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)subcommentButtonClick:(UIButton *)sender {
    
}

- (void)commentButtonClick:(UIButton *)sender {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDDCommentModel *comment = self.list[indexPath.section];
    if (!indexPath.row) {
        return comment.content_height + 20 + 20 + 5 + 5 + 20 + 20;
    }
    YMHLSubCommentsModel *subcomment = comment.subcomments[indexPath.row - 1];
    return subcomment.content_height + 20 + 20 + 5 + 5 + 20 + 20;
}

- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player {
    SPDefaultControlView *controlView = (SPDefaultControlView *)player.controlView;
    if (player.isFullScreen) {
        controlView.danmakuBtn.hidden = YES;
        controlView.captureBtn.hidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.playerView resetPlayer];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
