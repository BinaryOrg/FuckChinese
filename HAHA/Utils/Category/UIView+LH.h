//
//  UIView+LH.h
//  小灯塔
//
//  Created by Hasten on 2018/2/27.
//  Copyright © 2018年 Maker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LH)
/** 快速返回frame的属性 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGPoint origin;

/**
 *  快速找出当前view所在的控制器
 */
-(UIViewController *)viewController;
/**
 *  快速保存数据
 */
@property (nonatomic,retain) id extra;

/**
 *  快速取出数据
 */
-(id)extra;
/**
 *  快速保存数据
 */
-(void)setExtra:(id)extra;

/**
 * 加载xib创建的view
 */
+ (instancetype)viewFromXib;

#pragma mark - SafeArea

+ (CGFloat)safeAreaTop;
+ (CGFloat)safeAreaBottom;
+ (CGFloat)safeAreaLeft;
+ (CGFloat)safeAreaRight;

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

@end

