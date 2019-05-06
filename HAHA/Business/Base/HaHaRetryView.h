//
//  HaHaRetryView.h
//  HAHA
//
//  Created by Maker on 2019/4/2.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HaHaRetryViewBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface HaHaRetryView : UIView

/** <#class#> */
@property (nonatomic, copy) HaHaRetryViewBlock block;

@end

NS_ASSUME_NONNULL_END
