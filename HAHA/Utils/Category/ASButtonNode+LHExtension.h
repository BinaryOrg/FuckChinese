//
//  ASButtonNode+LHExtension.h
//  小灯塔
//
//  Created by Maker on 2018/11/26.
//  Copyright © 2018 Maker. All rights reserved.
//


@interface ASButtonNode (LHExtension)

/** 扩大buuton点击范围  */
- (void)lh_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left;

@end

