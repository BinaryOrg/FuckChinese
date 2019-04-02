//
//  ZDDThridController.h
//  笑笑
//
//  Created by Maker on 2019/3/28.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import "ZDDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDDThridController : YMHLBaseViewController
/**
 0 - 自己
 1 - 他人
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *user_id;
@end

NS_ASSUME_NONNULL_END
