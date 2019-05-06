//
//  HaHaInputView.h
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HaHaInputViewBlock)(void);


NS_ASSUME_NONNULL_BEGIN

@interface HaHaInputView : UIView

@property (nonatomic, strong, readonly) UITextView *textView;

@property (nonatomic, copy) HaHaInputViewBlock inputViewBlock;
- (void)show;
- (void)dismissAndRemove;

@end

NS_ASSUME_NONNULL_END
