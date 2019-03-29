//
//  YMHLVideoCollectionViewCell.h
//  笑笑
//
//  Created by 张冬冬 on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYImage/YYImage.h>
#import <TTAnimationButton/TTAnimationButton.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMHLVideoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) YYAnimatedImageView *coverImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nickLabel;

@property (nonatomic, strong) TTAnimationButton *imgButton;
@end

NS_ASSUME_NONNULL_END
