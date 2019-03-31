//
//  YMHLCommentTableViewCell.m
//  HAHA
//
//  Created by ZDD on 2019/3/31.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLCommentTableViewCell.h"

@implementation YMHLCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        self.avatar.layer.cornerRadius = 20;
        self.avatar.layer.masksToBounds = YES;
        
        self.avatar.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.avatar];
        
        self.nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatar) + 20, 20, 150, 20)];
        self.nickLabel.textColor = [UIColor zdd_colorWithRed:51 green:51 blue:51];
        self.nickLabel.font  = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:self.nickLabel];
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.nickLabel), MaxY(self.nickLabel) + 5, SCREENWIDTH - 100, 0)];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.textColor = [UIColor zdd_colorWithRed:80 green:80 blue:80];
        self.commentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.commentLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.commentLabel), 0, 100, 20)];
        self.dateLabel.textColor = [UIColor zdd_colorWithRed:180 green:180 blue:180];
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.dateLabel];
        
        self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *i = [[UIImage imageNamed:@"ZHDB_Badge_Comment"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        self.commentButton.tintColor = [UIColor zdd_colorWithRed:120 green:120 blue:120];
        [self.commentButton setImage:i forState:UIControlStateNormal];
        self.commentButton.frame = CGRectMake(SCREENWIDTH - 20 - 20, 0, 20, 20);
        [self.contentView addSubview:self.commentButton];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
