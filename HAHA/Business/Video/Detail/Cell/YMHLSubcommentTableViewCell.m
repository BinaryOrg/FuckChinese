//
//  YMHLSubcommentTableViewCell.m
//  HAHA
//
//  Created by ZDD on 2019/3/31.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLSubcommentTableViewCell.h"

@implementation YMHLSubcommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatar = [[UIImageView alloc] initWithFrame:CGRectMake(80, 20, 20, 20)];
        self.avatar.layer.cornerRadius = 10;
        self.avatar.layer.masksToBounds = YES;
        
        self.avatar.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.avatar];
        
        self.src_nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.avatar) + 20, 20, 50, 20)];
        self.src_nickLabel.textColor = [UIColor zdd_colorWithRed:51 green:51 blue:51];
        self.src_nickLabel.font  = [UIFont systemFontOfSize:16];
        self.src_nickLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIImageView *src = [[UIImageView alloc] initWithFrame:CGRectMake(MaxX(self.src_nickLabel)+5, 27, 5, 6)];
        src.image = [UIImage imageNamed:@"ReplyTo"];
        [self.contentView addSubview:src];
        
        self.tar_nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(src) + 5, 20, 50, 20)];
        self.tar_nickLabel.textColor = [UIColor zdd_colorWithRed:51 green:51 blue:51];
        self.tar_nickLabel.font  = [UIFont systemFontOfSize:16];
        self.tar_nickLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self.contentView addSubview:self.src_nickLabel];
        [self.contentView addSubview:self.tar_nickLabel];
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(MinX(self.src_nickLabel), MaxY(self.src_nickLabel) + 5, SCREENWIDTH - 100, 0)];
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
