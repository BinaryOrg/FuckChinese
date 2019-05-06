//
//  HaHaInputView.m
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "HaHaInputView.h"

@interface HaHaInputView ()

/** 评论编辑框 */
@property (nonatomic, strong) UITextView *textView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** tips */
@property (nonatomic, strong) UILabel *tipLb;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *masking;

@end

@implementation HaHaInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        // 弹出事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        // 隐藏事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [self.sendButton addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Public 方法
- (void)sendSuccess {
    self.textView.text = nil;
}

#pragma mark - Action
- (void)sendBtnClick{
    if (self.inputViewBlock) {
        self.inputViewBlock();
    }
    [self dismissAndRemove];
}

- (void)clikClose {
    [self dismissAndRemove];
}

- (void)setTipsString:(NSString *)tipsString {
    self.tipLb.text = tipsString;
}

#pragma mark - 动画
- (void)show {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    self.masking.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [self layoutIfNeeded];
    [self.textView becomeFirstResponder];
    
}

- (void)dismissAndRemove {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.textView.text = @"";
        self.masking.alpha = 0.0f;
        [self removeFromSuperview];
    }];
}


#pragma mark - noti Action
- (void)kbWillShow:(NSNotification *)noti {
    // 动画的持续时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.获取键盘的高度
    CGRect kbFrame =  [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- kbHeight);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        self.masking.alpha = 1.0f;
        [self.superview layoutIfNeeded];
    }];
    
    
}

- (void)kbWillHide:(NSNotification *)noti {
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SafeTabBarHeight);
    }];
    
    
    [self.textView resignFirstResponder];
}

#pragma mark - 添加子控件的约束
- (void)makeSubViewsConstraints {
    
    [self addSubview:self.masking];
    self.masking.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    [self addSubview:self.tipLb];
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(60);
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.centerY.mas_equalTo(self.tipLb);
        make.width.height.mas_equalTo(20);
    }];
    
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLb.mas_bottom).mas_equalTo(18);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo( - SafeAreaBottomHeight);
    }];
    
    
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.textView.mas_bottom).mas_equalTo(-20);
        make.right.mas_equalTo(self.textView.mas_right).mas_equalTo(-20);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _textView.textColor = color(53, 64, 72, 1);
        _textView.textContainerInset = UIEdgeInsetsMake(20, 10, 20, 20);
        _textView.layer.cornerRadius = 8;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _sendButton.backgroundColor = [UIColor darkGrayColor];
        _sendButton.layer.cornerRadius = 12.5;
        _sendButton.layer.masksToBounds = YES;
    }
    return _sendButton;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clikClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)tipLb {
    if (!_tipLb) {
        _tipLb = [[UILabel alloc] init];
        _tipLb.text = @" 这是一条有笑料的评论~";
        _tipLb.font = [UIFont systemFontOfSize:18];
        _tipLb.textColor = [UIColor whiteColor];
    }
    return _tipLb;
}

-(UIButton *)masking {
    if (!_masking) {
        _masking = [UIButton buttonWithType:UIButtonTypeCustom];
        [_masking addTarget:self action:@selector(dismissAndRemove) forControlEvents:UIControlEventTouchUpInside];
        [_masking setBackgroundColor:[UIColor darkGrayColor]];
        [_masking setAlpha:0.0f];
    }
    return _masking;
}

@end
