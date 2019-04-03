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
#import "ZDDPostDyController.h"
#import "ZDDThridController.h"

@interface ZDDSecondController ()<ZDDSecondListCellNodeDelegate>

@property (nonatomic, strong) NSMutableArray <ZDDDuanziModel *>*dataArr;
@property (nonatomic, assign) NSInteger page;

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerRefresh) name:@"shouldReloadDy" object:nil ];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
- (void)clickPostDyBtn {
    ZDDPostDyController *vc = [ZDDPostDyController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//点击头像
- (void)clickIconWithModel:(GODUserModel *)model {
    ZDDThridController *t = [ZDDThridController new];
    t.type = 1;
    t.user_id = model.user_id;
    [self.navigationController pushViewController:t animated:YES];
}

#pragma mark - 网路请求
- (void)headerRefresh {
    _page = 1;
    [self loadData:NO];
}

- (void)footerRefresh {
    [self loadData:YES];
}

- (void)loadData:(BOOL)isAdd {
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Duanzi/ListDynamic" params:@{@"userId": [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"", @"category" : @"graph_text", @"page": @(_page)} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        [self endFooterRefresh];
        if (statusCode == 200) {
            if (!isAdd) {
                [self.dataArr removeAllObjects];
            }
            NSArray *tempArr = [NSArray yy_modelArrayWithClass:ZDDDuanziModel.class json:result[@"data"]];
            if (tempArr.count) {
                [self.dataArr addObjectsFromArray:tempArr];
                [self.tableNode reloadData];
                self.page++;
            }
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
        node.delegate = self;
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
