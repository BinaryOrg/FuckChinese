
//
//  NSString+YMHLAdditions.m
//  HAHA
//
//  Created by HaHa on 2019/3/31.
//  Copyright © 2019 HaHa. All rights reserved.
//

#import "NSString+YMHLAdditions.h"

@implementation NSString (YMHLAdditions)
#pragma mark - 计算文本高度
- (CGFloat)heightWithLabelFont:(UIFont *)font withLabelWidth:(CGFloat)width {
    CGFloat height = 0;
    if (self.length == 0) {
        height = 0;
    } else {
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font) {
            attribute = @{NSFontAttributeName: font};
        }
        // 尺寸
        CGSize retSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
        height = retSize.height;
    }
    return height;
}
@end
