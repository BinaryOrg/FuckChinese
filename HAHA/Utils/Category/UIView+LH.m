//
//  UIView+LH.m
//  小灯塔
//
//  Created by Hasten on 2018/2/27.
//  Copyright © 2018年 Maker. All rights reserved.
//

#import "UIView+LH.h"
#import <objc/runtime.h>

static char isShowMaskKey;
@interface UIView ()

@property (nonatomic, assign) BOOL isShowMask;

@end

@implementation UIView (LH)
/**
 *  快速找出当前view所在的控制器
 */
-(UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
#pragma mark - 快速返回frame的属性
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setMaxX:(CGFloat)maxX
{
    self.x = maxX - self.width;
}


- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    self.y = maxY - self.height;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

@dynamic extra;

-(id)extra
{
    return objc_getAssociatedObject(self,@"uiview_extra");
}

-(void)setExtra:(id)extra
{
    objc_setAssociatedObject(self,@"uiview_extra",extra,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (instancetype)viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

-(void)backButtonDidClick:(UIButton *)button
{
    if([button viewController])
    {
        if ([button viewController].presentingViewController) {
            [[button viewController] dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[button viewController].navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - SA
+ (CGFloat)safeAreaTop {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
    }
    return .0f;
}

+ (CGFloat)safeAreaBottom {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    return .0f;
}

+ (CGFloat)safeAreaLeft {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.left;
    }
    return .0f;
}

+ (CGFloat)safeAreaRight {
    if (@available(iOS 11, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.right;
    }
    return .0f;
}

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}


#pragma mark - Getter
- (BOOL)isShowMask {
    id isShowMask = objc_getAssociatedObject(self, &isShowMaskKey);
    return [isShowMask boolValue];
}

- (void)setIsShowMask:(BOOL)isShowMask
{
    objc_setAssociatedObject(self, &isShowMaskKey, @(isShowMask), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

