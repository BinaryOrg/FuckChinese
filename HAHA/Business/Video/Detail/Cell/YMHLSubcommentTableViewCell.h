//
//  YMHLSubcommentTableViewCell.h
//  HAHA
//
//  Created by ZDD on 2019/3/31.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMHLSubcommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *avatarButton;

@property (nonatomic, strong) UILabel *src_nickLabel;
@property (nonatomic, strong) UILabel *tar_nickLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UIButton *dotButton;
@end

NS_ASSUME_NONNULL_END
