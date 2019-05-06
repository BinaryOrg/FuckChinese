//
//  PersonDuanziController.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/3.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "PersonDuanziController.h"
#import "HaHaSecondListCellNode.h"
#import "HaHaCommentListController.h"
#import "HaHaThridController.h"

@interface PersonDuanziController ()
<HaHaSecondListCellNodeDelegate>
@property (nonatomic, strong) NSMutableArray <HaHaDuanziModel *>*dataArr;
@end

@implementation PersonDuanziController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableNode];
    self.showRefrehHeader = YES;
    [self headerRefresh];
    self.navigationItem.title = @"我的动态";
}

//点击头像
- (void)clickIconWithModel:(GODUserModel *)model {
    HaHaThridController *t = [HaHaThridController new];
    t.type = 1;
    t.user_id = model.user_id;
    [self.navigationController pushViewController:t animated:YES];
}

#pragma mark - 网路请求
- (void)headerRefresh {
    [self loadData:NO];
}


- (void)loadData:(BOOL)isAdd {
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"http://120.78.124.36:10010/MRYX/Duanzi/ListDynamicByUserId" params:@{@"userId": self.user_id ?:@""} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        if ([result[@"resultCode"] isEqualToString:@"0"]) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:HaHaDuanziModel.class json:result[@"data"]]];
            
            if (self.dataArr.count) {
                [self.tableNode reloadData];
            }else {
                [self addEmptyView];
            }
        }
        else {
            [MFHUDManager showError:@"刷新失败请重试"];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self endHeaderRefresh];
        [MFHUDManager showError:@"刷新失败请重试"];
    }];
}


#pragma mark - tableNode
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *(){
        HaHaSecondListCellNode *node = [[HaHaSecondListCellNode alloc] initWithModel:self.dataArr[indexPath.row]];
        node.delegate = self;
        return node;
    };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([GODUserTool isLogin]) {
        HaHaDuanziModel *model = self.dataArr[indexPath.row];
        HaHaCommentListController *vc = [HaHaCommentListController new];
        [self.navigationController pushViewController:vc animated:YES];
        vc.model = model;
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
@end
