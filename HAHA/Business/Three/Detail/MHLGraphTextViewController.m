//
//  MHLGraphTextViewController.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/3.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "MHLGraphTextViewController.h"
#import "HaHaFistListCellNode.h"
#import "HaHaCommentLIstView.h"
#import "HaHaLogInController.h"

@interface MHLGraphTextViewController ()
@property (nonatomic, strong) HaHaCommentLIstView *commentListView;
@property (nonatomic, strong) NSMutableArray <HaHaDuanziModel *>*dataArr;
@end

@implementation MHLGraphTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的图文";
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
            [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:HaHaDuanziModel.class json:result[@"data"][@"graph_text"]]];
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

- (void)geitCommentListWithModel:(HaHaDuanziModel *)model {
    if (model.id.length == 0) {
        return;
    }
    [MFHUDManager showLoading:@"获取评论列表..."];
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Comment/ListCommentByTargetid" params:@{@"targetId" : model.id} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        if (statusCode == 200) {
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:HaHaCommentModel.class json:result[@"data"]];
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
        HaHaFistListCellNode *node = [[HaHaFistListCellNode alloc] initWithModel:self.dataArr[indexPath.row]];
        return node;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GODUserTool isLogin]) {
        HaHaDuanziModel *model = self.dataArr[indexPath.row];
        [self geitCommentListWithModel:model];
    }else {
        HaHaLogInController *vc = [HaHaLogInController new];
        [self.navigationController presentViewController:vc animated:YES completion:nil] ;
    }
    
}

#pragma mark - 懒加载
- (NSMutableArray <HaHaDuanziModel *>*)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (HaHaCommentLIstView *)commentListView {
    if (!_commentListView) {
        _commentListView = [[HaHaCommentLIstView alloc] init];
    }
    return _commentListView;
}
@end
