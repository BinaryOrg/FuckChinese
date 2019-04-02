//
//  YMHLPeronHeaderTableViewCell.m
//  HAHA
//
//  Created by ZDD on 2019/4/1.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLPeronHeaderTableViewCell.h"

@implementation YMHLPeronHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.userInteractionEnabled = YES;
        self.bgImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bgImageView.bounds];
        bgView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        [self.bgImageView addSubview:bgView];
        
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 75, 60, 60)];
        self.avatarImageView.layer.cornerRadius = 30;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.avatarImageView];
        
        self.nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MaxY(self.avatarImageView) + 15, 150, 30)];
        self.nickLabel.font = [UIFont systemFontOfSize:20];
        self.nickLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.nickLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, MaxY(self.nickLabel) + 15, 150, 30)];
        self.dateLabel.font = [UIFont systemFontOfSize:15];
        self.dateLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.dateLabel];
        
        self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.loginButton.frame = CGRectMake(SCREENWIDTH - 90, 90, 70, 30);
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        self.loginButton.layer.cornerRadius = 5;
        self.loginButton.layer.masksToBounds = YES;
        self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.loginButton.layer.borderWidth = 1;
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.loginButton];
    }
    return self;
}

@end
