//
//  ZDDCommentLIstView.m
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDCommentLIstView.h"

@interface ZDDCommentLIstView ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@end


@implementation ZDDCommentLIstView

- (instancetype)init {
    if (self = [super init]) {
        [self addTableNode];
    }
    return self;
}


- (void)addTableNode {
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.backgroundColor = [UIColor whiteColor];
    _tableNode.view.estimatedRowHeight = 0;
    _tableNode.leadingScreensForBatching = 1.0;
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self addSubview:_tableNode.view];
    [_tableNode.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
}



@end
