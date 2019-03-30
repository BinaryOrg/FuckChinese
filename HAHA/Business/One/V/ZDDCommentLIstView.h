//
//  ZDDCommentLIstView.h
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZDDCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDCommentLIstView : UIView

- (void)showWithArray:(NSArray <ZDDCommentModel *> *)array duanziID:(NSString *)duanziID;

- (void)dismissAndRemove;

@end

NS_ASSUME_NONNULL_END
