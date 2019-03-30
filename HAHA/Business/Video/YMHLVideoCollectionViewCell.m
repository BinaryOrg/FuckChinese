//
//  YMHLVideoCollectionViewCell.m
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "YMHLVideoCollectionViewCell.h"
#import <Masonry/Masonry.h>
@implementation YMHLVideoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *container = [[UIView alloc] init];
        [self.contentView addSubview:container];
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(0);
        }];
        
        
        self.coverImageView = [[YYAnimatedImageView alloc] init];
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.layer.cornerRadius = 5;
        [container addSubview:self.coverImageView];
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-80);
        }];
        
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.numberOfLines = 2;
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        
        [container addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverImageView.mas_bottom).offset(5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        
        
        self.avatar = [[UIImageView alloc] init];
        self.avatar.contentMode = UIViewContentModeScaleAspectFill;
        self.avatar.layer.masksToBounds = YES;
        self.avatar.layer.cornerRadius = 10;
        [container addSubview:self.avatar];
        
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.width.height.mas_equalTo(20);
        }];
        
        self.imgButton = [TTAnimationButton buttonWithType:UIButtonTypeCustom];
        [self.imgButton setImage:[UIImage imageNamed:@"disLike"] forState:UIControlStateNormal];
        self.imgButton.imageSelectedColor = [UIColor zdd_redColor];
        self.imgButton.explosionRate = 100;
        [container addSubview:self.imgButton];
        [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(-10);
            make.width.height.mas_equalTo(20);
        }];
        
        self.nickLabel = [[UILabel alloc] init];
        self.nickLabel.font = [UIFont systemFontOfSize:12];
        self.nickLabel.textColor = [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
        [container addSubview:self.nickLabel];
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatar.mas_right).offset(10);
            make.right.equalTo(self.imgButton.mas_left).offset(5);
            make.height.mas_equalTo(20);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        }];
        
        
    }
    return self;
}
@end
