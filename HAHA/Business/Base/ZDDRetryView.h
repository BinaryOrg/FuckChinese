//
//  ZDDRetryView.h
//  HAHA
//
//  Created by Maker on 2019/4/2.
//  Copyright © 2019 ZDD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZDDRetryViewBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface ZDDRetryView : UIView

/** <#class#> */
@property (nonatomic, copy) ZDDRetryViewBlock block;

@end

NS_ASSUME_NONNULL_END
