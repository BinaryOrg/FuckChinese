//
//  MHLGraphTextViewController.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/3.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "MHLGraphTextViewController.h"
#import "ZDDFistListCellNode.h"
#import "ZDDCommentLIstView.h"
#import "ZDDLogInController.h"

@interface MHLGraphTextViewController ()
@property (nonatomic, strong) ZDDCommentLIstView *commentListView;
@property (nonatomic, strong) NSMutableArray <ZDDDuanziModel *>*dataArr;
@end

@implementation MHLGraphTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableNode];
    self.showRefrehHeader = YES;
    [self headerRefresh];
}
- (void)headerRefresh {
    
    [self loadData:NO];
}

- (void)loadData:(BOOL)isAdd {
    
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Duanzi/ListStaredDuanziByUserId" params:@{@"userId": self.user_id ?:@"",} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        if ([result[@"resultCode"] isEqualToString:@"0"]) {
            
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:ZDDDuanziModel.class json:result[@"data"][@"graph_text"]]];
            if (self.dataArr.count) {
                [self.tableNode reloadData];
            }else {
                [self addEmptyView];
            }
        }else {
            [self addEmptyView];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        [self addEmptyView];
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
