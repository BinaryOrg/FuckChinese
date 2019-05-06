//
//  HaHaRetryView.m
//  HAHA
//
//  Created by Maker on 2019/4/2.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "HaHaRetryView.h"

@implementation HaHaRetryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:GODColor(53, 64, 72) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setShowsTouchWhenHighlighted:NO];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = GODColor(137, 137, 137).CGColor;
        [btn addTarget:self action:@selector(clickRetry) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}

- (void)clickRetry {
    if (self.block) {
        self.block();
    }
}

@end
