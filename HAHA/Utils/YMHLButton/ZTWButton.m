//
//  ZTWButton.m
//  ZhiYun
//
//  Created by 张冬冬 on 2019/3/7.
//  Copyright © 2019 张冬冬. All rights reserved.
//

#import "ZTWButton.h"

@implementation ZTWButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    
    CGRect bounds = self.bounds;
    CGFloat widthExtra = MAX(self.eventFrame.width - bounds.size.width, 0);
    CGFloat heightExtra = MAX(self.eventFrame.height - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthExtra, -0.5 * heightExtra);
    return CGRectContainsPoint(bounds, point);
}

@end
