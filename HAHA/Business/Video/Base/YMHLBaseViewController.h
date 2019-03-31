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
typedef void(^BottomErrorViewClickBlock)(void);
@interface YMHLBaseViewController : UIViewController
- (void)addEmptyView;
- (void)addNetworkErrorView;
- (void)removeErrorView;

- (void)addBottomErrorView;
- (void)removeBottomErrorView;
@property (nonatomic, copy) ErrorViewClickBlock errorViewClickBlock;
@property (nonatomic, copy) BottomErrorViewClickBlock bottomErrorViewClickBlock;
@end

NS_ASSUME_NONNULL_END
