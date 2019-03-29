//
//  ZDDInputView.m
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDInputView.h"

@interface ZDDInputView ()

/** 评论编辑框 */
@property (nonatomic, strong) UITextView *textView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** tips */
@property (nonatomic, strong) UILabel *tipLb;

@property (nonatomic, strong) UIButton *masking;

@end

@implementation ZDDInputView

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"text"];
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
#pragma mark - noti Action
- (void)kbWillShow:(NSNotification *)noti {
    // 动画的持续时间
    self.hidden = NO;
    
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.获取键盘的高度
    CGRect kbFrame =  [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFrame.size.height;
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(- kbHeight);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        self.masking.alpha = 0.5;
        [self.superview layoutIfNeeded];
    }];
    
    
}

- (void)kbWillHide:(NSNotification *)noti {
    
    self.textView.text = @"";
    // 动画的持续时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SafeTabBarHeight);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        self.masking.alpha = 0.0f;
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
    [self.textView resignFirstResponder];
}

- (void)dismissAndRemove {
    [self.textView resignFirstResponder];
}


#pragma mark - 添加子控件的约束
- (void)makeSubViewsConstraints {
    
    [self addSubview:self.masking];
    self.masking.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    
    [self.masking addSubview:self.tipLb];
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(80);
    }];
    
    
    [self.masking addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLb.mas_bottom);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(35);
    }];
    
    
    [self.textView addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(19);
        
    }];
    
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        _textView.textColor = color(53, 64, 72, 1);
        _textView.layer.cornerRadius = 8;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _sendButton;
}

- (UILabel *)tipLb {
    if (!_tipLb) {
        _tipLb = [[UILabel alloc] init];
        _tipLb.text = @"这是一条有笑料的评论~";
    }
    return _tipLb;
}

-(UIButton *)masking {
    if (!_masking) {
        _masking = [UIButton buttonWithType:UIButtonTypeCustom];
        [_masking addTarget:self action:@selector(dismissAndRemove) forControlEvents:UIControlEventTouchUpInside];
        [_masking setBackgroundColor:[UIColor blackColor]];
        [_masking setAlpha:0.0f];
    }
    return _masking;
}

@end
