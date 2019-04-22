//
//  YMHLCommentTableViewCell.h
//  HAHA
//
//  Created by ZDD on 2019/3/31.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTWButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface YMHLCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) ZTWButton *starButton;
@property (nonatomic, strong) ZTWButton *commentButton;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *dotButton;
@end

NS_ASSUME_NONNULL_END
