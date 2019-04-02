//
//  YMHLPersonLogoutTableViewCell.m
//  HAHA
//
//  Created by 张冬冬 on 2019/4/2.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import "YMHLPersonLogoutTableViewCell.h"

@implementation YMHLPersonLogoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        self.nameLabel.textColor = [UIColor zdd_redColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

@end
