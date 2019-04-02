//
//  ZDDCommentListController.m
//  HAHA
//
//  Created by Maker on 2019/4/1.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "ZDDCommentListController.h"
#import "ZDDCommentCellNode.h"
#import "ZDDInputView.h"
#import "ZDDSecondListCellNode.h"

@interface ZDDCommentListController ()

@property (nonatomic, strong) ZDDInputView *inputView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIButton *writeBtn;

@end

@implementation ZDDCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论列表";
    [self addTableNode];
    [self.view addSubview:self.writeBtn];
    [self.writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.mas_equalTo(-20.0f);
        make.bottom.mas_equalTo(-(SafeAreaBottomHeight + 60.0f));
    }];

}

- (void)setModel:(ZDDDuanziModel *)model {
    _model = model;
    [self headerRefresh];
}

- (void)clickwriteBtn {
    [self.inputView show];
    __weak typeof(self)weakSelf = self;
    self.inputView.inputViewBlock = ^{
        [weakSelf addComment];
    };
}

- (void)addComment {
    if (self.inputView.textView.text.length == 0) {
        return;
    }
    [MFHUDManager showLoading:@"评论一下..."];
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Comment/Create" params:@{@"userId" : [GODUserTool shared].user.user_id.length ? [GODUserTool shared].user.user_id : @"", @"targetId" : self.model.id, @"content" : self.inputView.textView.text} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        if (statusCode == 200) {
            ZDDCommentModel *addModel = [ZDDCommentModel yy_modelWithJSON:result[@"comment"]];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dataArr];
            [tempArr insertObject:addModel atIndex:0];
            self.dataArr = tempArr.copy;
            self.model.comment_num += 1;
        }else {
            [MFHUDManager showError:@"评论失败请重试"];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        [MFHUDManager showError:@"评论失败请重试"];
    }];
}

#pragma mark - 网路请求
- (void)headerRefresh {
    
    [MFHUDManager showLoading:@"获取评论列表..."];
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;
    [MFNETWROK post:@"Comment/ListCommentByTargetid" params:@{@"targetId" : self.model.id} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        if (statusCode == 200) {
            self.dataArr = [NSArray yy_modelArrayWithClass:ZDDCommentModel.class json:result[@"data"]];
            [self.tableNode reloadData];
        }else {
            [MFHUDManager showError:@"刷新失败请重试"];
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager dismiss];
        [MFHUDManager showError:@"刷新失败请重试"];
    }];
}


#pragma mark - tableNodeDelegate
- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 2;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *() {
        if (indexPath.section == 0) {
            ZDDSecondListCellNode *node = [[ZDDSecondListCellNode alloc] initWithModel:self.model];
            return node;
        }
        ZDDCommentCellNode *node = [[ZDDCommentCellNode alloc] initWithModel:self.dataArr[indexPath.row]];
        node.bgvEdge = UIEdgeInsetsMake(-20, -10, -30, -10);
        node.backgroundColor = color(237, 237, 237, 0.5);
        return node;
    };
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UILabel *lb = [UILabel new];
    lb.frame = CGRectMake(0, 0, ScreenWidth, 60);
    UIView *lineView = [UIView new];
    lineView.backgroundColor = GODColor(237,237, 237);
    lb.attributedText = [NSMutableAttributedString lh_makeAttributedString:[NSString stringWithFormat:@"    精彩评论 (%ld)", self.dataArr.count] attributes:^(NSMutableDictionary *make) {
        make.lh_font([UIFont systemFontOfSize:18]).lh_color([UIColor blackColor]);
    }];
    return lb;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.05;
    }
    return 60;
}

#pragma mark - 懒加载
- (ZDDInputView *)inputView {
    if (!_inputView) {
        _inputView = [[ZDDInputView alloc] init];
    }
    return _inputView;
}

-(UIButton *)writeBtn {
    if (!_writeBtn) {
        _writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _writeBtn.backgroundColor = [UIColor whiteColor];
        _writeBtn.layer.cornerRadius = 30;
        _writeBtn.layer.shadowColor = [UIColor qmui_colorWithHexString:@"433C33"].CGColor;
        _writeBtn.layer.shadowOffset = CGSizeMake(.0f, 1.0f);
        _writeBtn.layer.shadowOpacity = .12f;
        _writeBtn.layer.shadowRadius = 4.0f;
        [_writeBtn setImage:[UIImage imageNamed:@"btn_postings"] forState:UIControlStateNormal];
        [_writeBtn addTarget:self action:@selector(clickwriteBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _writeBtn;
}
@end
