//
//  ZDDInputView.h
//  笑笑
//
//  Created by Maker on 2019/3/29.
//  Copyright © 2019 MakerYang.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZDDInputViewBlock)(void);


NS_ASSUME_NONNULL_BEGIN

@interface ZDDInputView : UIView

@property (nonatomic, strong, readonly) UITextView *textView;

@property (nonatomic, copy) ZDDInputViewBlock inputViewBlock;
- (void)show;
- (void)dismissAndRemove;

@end

NS_ASSUME_NONNULL_END
