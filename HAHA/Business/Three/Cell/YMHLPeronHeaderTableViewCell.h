//
//  YMHLPeronHeaderTableViewCell.h
//  HAHA
//
//  Created by ZDD on 2019/4/1.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMHLPeronHeaderTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIButton *loginButton;
@end

NS_ASSUME_NONNULL_END
