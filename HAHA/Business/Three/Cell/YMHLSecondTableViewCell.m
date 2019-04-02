//
//  YMHLSecondTableViewCell.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/2.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLSecondTableViewCell.h"

@implementation YMHLSecondTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        self.leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.leftImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(self.leftImageView) + 20, 10, 100, 30)];
        self.nameLabel.textColor = [UIColor zdd_colorWithRed:51 green:51 blue:51];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

@end
