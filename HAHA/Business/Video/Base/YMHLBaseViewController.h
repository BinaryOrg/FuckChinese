//
//  YMHLBaseViewController.h
//  HAHA
//
//  Created by ZDD on 2019/3/30.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ErrorViewClickBlock)(void);
@interface YMHLBaseViewController : UIViewController
- (void)addEmptyView;
- (void)addNetworkErrorView;
- (void)removeErrorView;

@property (nonatomic, copy) ErrorViewClickBlock errorViewClickBlock;
@end

NS_ASSUME_NONNULL_END
