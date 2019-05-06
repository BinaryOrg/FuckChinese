//
//  HaHaCommentLIstView.h
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HaHaDuanziModel.h"
#import "HaHaCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HaHaCommentLIstView : UIView

- (void)showWithArray:(NSArray <HaHaCommentModel *> *)array duanzi:(HaHaDuanziModel *)model;

- (void)dismissAndRemove;

@end

NS_ASSUME_NONNULL_END
