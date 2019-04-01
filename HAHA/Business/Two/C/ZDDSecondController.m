//
//  ZDDSecondController.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDSecondController.h"
#import "ZDDSecondListCellNode.h"
#import "ZDDCommentListController.h"

@interface ZDDSecondController ()

@property (nonatomic, strong) NSMutableArray <ZDDDuanziModel *>*dataArr;

@end

@implementation ZDDSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableNode];
    self.showRefrehHeader = YES;
    self.showRefrehFooter = YES;
    [self headerRefresh];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [nextButton setTitleColor:[UIColor qmui_colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [nextButton setTitle:@"发布" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(clickPostDyBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    
}

- (void)clickPostDyBtn {
    
    
}

#pragma mark - 网路请求
- (void)headerRefresh {
    
    [self loadData:NO];
}

- (void)footerRefresh {
    [self loadData:YES];
}

- (void)loadData:(BOOL)isAdd {
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Duanzi/ListDynamic" params:@{@"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"", @"category" : @"graph_text"} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
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


#pragma mark - tableNode
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *(){
        ZDDSecondListCellNode *node = [[ZDDSecondListCellNode alloc] initWithModel:self.dataArr[indexPath.row]];
        return node;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GODUserTool isLogin]) {
        ZDDDuanziModel *model = self.dataArr[indexPath.row];
        ZDDCommentListController *vc = [ZDDCommentListController new];
        [self.navigationController pushViewController:vc animated:YES];
        vc.model = model;
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

@end
