//
//  ZDDFirstController.m
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDFirstController.h"
#import "ZDDFistListCellNode.h"

@interface ZDDFirstController ()

/** <#class#> */
@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation ZDDFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"笑笑";
    [self addTableNode];
    self.showRefrehHeader = YES;;
    self.showRefrehFooter = YES;
    [self.tableNode reloadData];
}

- (void)headerRefresh {
    
}

- (void)footerRefresh {
    
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 20;//self.dataArr.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *(){
        ZDDFistListCellNode *node = [[ZDDFistListCellNode alloc] init];
        return node;
    };
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
