//
//  ZDDFirstController.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDFirstController.h"
#import "ZDDFistListCellNode.h"
#import "ZDDCommentLIstView.h"
#import "ZDDLogInController.h"

@interface ZDDFirstController ()

@property (nonatomic, strong) ZDDCommentLIstView *commentListView;
@property (nonatomic, strong) NSMutableArray <ZDDDuanziModel *>*dataArr;


@end

@implementation ZDDFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableNode];
    self.showRefrehHeader = YES;
    self.showRefrehFooter = YES;
    [self headerRefresh];
}

#pragma mark - 网路请求
- (void)headerRefresh {
    
    [self loadData:NO];
}

- (void)footerRefresh {
    
    [self loadData:YES];
}

- (void)loadData:(BOOL)isAdd {
    
    NSInteger page = 1;
    if (isAdd) {
        page += self.dataArr.count/20;
    }
    
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Duanzi/ListRecommendDuanzi" params:@{@"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"", @"category" : @"graph_text", @"page" : @(page)} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        [self endFooterRefresh];
        if (statusCode == 200) {
            if (!isAdd) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:ZDDDuanziModel.class json:result[@"data"]]];
            [self.tableNode reloadData];
        }else {
            [MFHUDManager showError:@"刷新失败请重试"];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        [self endFooterRefresh];
        [MFHUDManager showError:@"刷新失败请重试"];
    }];
}

- (void)geitCommentListWithModel:(ZDDDuanziModel *)model {
    if (model.id.length == 0) {
        return;
    }
    [MFHUDManager showLoading:@"获取评论列表..."];
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Comment/ListCommentByTargetid" params:@{@"targetId" : model.id} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        if (statusCode == 200) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:ZDDCommentModel.class json:result[@"data"]];
            [self.commentListView showWithArray:tempArr duanzi:model];
        }else {
            [MFHUDManager showError:@"刷新失败请重试"];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        [MFHUDManager showError:@"刷新失败请重试"];
    }];
}

#pragma mark - tableNode
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *(){
        ZDDFistListCellNode *node = [[ZDDFistListCellNode alloc] initWithModel:self.dataArr[indexPath.row]];
        return node;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GODUserTool isLogin]) {
        ZDDDuanziModel *model = self.dataArr[indexPath.row];
        [self geitCommentListWithModel:model];
    }else {
        ZDDLogInController *vc = [ZDDLogInController new];
        [self.navigationController presentViewController:vc animated:YES completion:nil] ;
    }
   
}

#pragma mark - 懒加载
- (NSMutableArray <ZDDDuanziModel *>*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (ZDDCommentLIstView *)commentListView {
    if (!_commentListView) {
        _commentListView = [[ZDDCommentLIstView alloc] init];
    }
    return _commentListView;
}

@end
