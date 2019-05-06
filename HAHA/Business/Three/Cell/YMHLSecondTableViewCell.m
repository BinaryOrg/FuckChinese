//
//  YMHLSecondTableViewCell.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/2.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "YMHLSecondTableViewCell.h"

@implementation YMHLSecondTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        self.nameLabel.textColor = [UIColor zdd_colorWithRed:51 green:51 blue:51];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

@end
