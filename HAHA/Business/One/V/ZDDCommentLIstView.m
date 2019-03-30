//
//  ZDDCommentLIstView.m
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDCommentLIstView.h"
#import "ZDDCommentCellNode.h"
#import <UIImage+YYAdd.h>

@interface ZDDCommentLIstView ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@property (nonatomic, strong) UIButton *writeBtn;

@end


@implementation ZDDCommentLIstView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]) {
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [visualView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAndRemove)]];
    visualView.userInteractionEnabled =YES;
    [self addSubview:visualView];

    
    
    _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableNode.backgroundColor = [UIColor clearColor];
    _tableNode.view.estimatedRowHeight = 0;
    _tableNode.leadingScreensForBatching = 1.0;
    _tableNode.delegate = self;
    _tableNode.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self addSubview:_tableNode.view];
    _tableNode.view.frame = CGRectMake(20, STATUSBARHEIGHT, ScreenWidth - 40, ScreenHeight - STATUSBARHEIGHT);
    [self addSubview:self.writeBtn];
    [self.writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.mas_equalTo(-20.0f);
        make.bottom.mas_equalTo(-(SafeAreaBottomHeight + 60.0f));
    }];
}

- (void)clickwriteBtn {
    
}

- (void)show {
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [self.tableNode reloadData];
    
//    [UIView animateWithDuration:02.5 animations:^{
//        self.tableNode.view.frame = CGRectMake(20, 0, ScreenWidth - 40, ScreenHeight);
//    }];
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         self->_tableNode.view.layer.transform = init;
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)dismissAndRemove {
    [UIView animateWithDuration:02.5 animations:^{
        self.tableNode.view.frame = CGRectMake(20, ScreenHeight, ScreenWidth - 40, ScreenHeight);;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - tableNodeDelegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *() {
        ZDDCommentCellNode *node = [[ZDDCommentCellNode alloc] init];
        
        return node;
    };
}


-(UIButton *)writeBtn {
    if (!_writeBtn) {
        _writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _writeBtn.backgroundColor = [UIColor yellowColor];
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
