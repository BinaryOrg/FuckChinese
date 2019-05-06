//
//  HaHaCommentLIstView.m
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "HaHaCommentLIstView.h"
#import "HaHaCommentCellNode.h"
#import <UIImage+YYAdd.h>
#import "POP.h"
#import "HaHaInputView.h"

@interface HaHaCommentLIstView ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableNode;

@property (nonatomic, strong) UIButton *writeBtn;

@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) UILabel *tipsLb;

@property (nonatomic, strong) HaHaInputView *inputView;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) HaHaDuanziModel *model;


@end


@implementation HaHaCommentLIstView

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

    [self addSubview:self.titleLb];
    self.titleLb.frame = CGRectMake(20, STATUSBARHEIGHT + 30, ScreenWidth - 40, 20);
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(self.titleLb);
        make.width.height.mas_equalTo(25);
    }];
    
    [self addSubview:self.tableNode.view];
    self.tableNode.view.frame = CGRectMake(20, ScreenHeight, ScreenWidth - 40, ScreenHeight - STATUSBARHEIGHT - 50);
    
    [self addSubview:self.writeBtn];
    [self.writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.right.mas_equalTo(-20.0f);
        make.bottom.mas_equalTo(-(SafeAreaBottomHeight + 60.0f));
    }];
    
    [self addSubview:self.tipsLb];
    [self.tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    if (dataArr.count == 0) {
        self.tipsLb.hidden = NO;
    }else {
        self.tipsLb.hidden = YES;
    }
    self.titleLb.text = [NSString stringWithFormat:@"评论（%ld）", dataArr.count];
    [self.tableNode reloadData];
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
            HaHaCommentModel *addModel = [HaHaCommentModel yy_modelWithJSON:result[@"comment"]];
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

- (void)showWithArray:(NSArray <HaHaCommentModel *> *)array duanzi:(HaHaDuanziModel *)model {

    self.model = model;
    self.dataArr = array;

    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    POPSpringAnimation *aniSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    aniSpring.toValue = @(ScreenHeight/2.0 + STATUSBARHEIGHT + 30);
    aniSpring.beginTime = CACurrentMediaTime();
    aniSpring.springBounciness = 6.0;
    
    [self.tableNode.view pop_addAnimation:aniSpring forKey:@"myRedViewposition"];
    
    [self heartAnimation];
}

- (void)dismissAndRemove {
    
    [self stopHeartAnimation];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableNode pop_animationForKey:@"myRedViewposition"];
        self.tableNode.view.frame = CGRectMake(20, ScreenHeight, ScreenWidth - 40, ScreenHeight - STATUSBARHEIGHT - 50);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)heartAnimation{
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.keyPath = @"transform.scale";
    anima.toValue = @0.5;
    anima.repeatCount = MAXFLOAT;
    anima.duration = 0.3;
    anima.autoreverses = YES;
    [self.writeBtn.layer addAnimation:anima forKey:@"shake"];
}


- (void)stopHeartAnimation{
    if ([self.writeBtn.layer animationForKey:@"shake"]) {
        [self.writeBtn.layer removeAllAnimations];
    }
}

#pragma mark - tableNodeDelegate
- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ^ASCellNode *() {
        HaHaCommentCellNode *node = [[HaHaCommentCellNode alloc] initWithModel:self.dataArr[indexPath.row]];
        
        return node;
    };
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

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:20];
        _titleLb.textColor = [UIColor whiteColor];
    }
    return _titleLb;
}

- (UILabel *)tipsLb {
    if (!_tipsLb) {
        _tipsLb = [[UILabel alloc] init];
        _tipsLb.font = [UIFont systemFontOfSize:15];
        _tipsLb.textColor = [UIColor whiteColor];
        _tipsLb.text = @"还没有评论喔，快去发布吧！";
    }
    return _tipsLb;
}

- (HaHaInputView *)inputView {
    if (!_inputView) {
        _inputView = [[HaHaInputView alloc] init];
     }
    return _inputView;
}

- (ASTableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableNode.backgroundColor = [UIColor clearColor];
        _tableNode.view.estimatedRowHeight = 0;
        _tableNode.leadingScreensForBatching = 1.0;
        _tableNode.view.showsVerticalScrollIndicator = NO;
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableNode.view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableNode;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismissAndRemove) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
@end
