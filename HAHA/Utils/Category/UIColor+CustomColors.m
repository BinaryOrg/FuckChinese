//
//  UIColor+CustomColors.m
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import "UIColor+CustomColors.h"
@implementation UIColor (CustomColors)

+ (UIColor *)themeColor {
    return [self colorWithRed:58 green:69 blue:77];
}

+ (UIColor *)textfieldBGColor {
    return [self colorWithRed:242 green:242 blue:242];
}

+ (UIColor *)couldColor {
    return [self colorWithRed:240 green:91 blue:72];
}
+ (UIColor *)couldnotColor {
    return [self colorWithRed:217 green:217 blue:217];
}

+ (UIColor *)tabColor {
    return [self colorWithRed:150 green:150 blue:150];
}

+ (UIColor *)startColor {
    return [self colorWithRed:58 green:78 blue:78];
}

+ (UIColor *)endColor {
    return [self colorWithRed:68 green:86 blue:69];
}

+ (UIColor *)customGrayColor
{
    return [self colorWithRed:84 green:84 blue:84];
}

+ (UIColor *)customRedColor
{
    return [self colorWithRed:231 green:76 blue:60];
}

+ (UIColor *)customYellowColor
{
    return [self colorWithRed:241 green:196 blue:15];
}

+ (UIColor *)customGreenColor
{
    return [self colorWithRed:46 green:204 blue:113];
}

+ (UIColor *)customBlueColor
{
    return [self colorWithRed:52 green:152 blue:219];
}

+ (UIColor *)customPurpleColor {
    return [self colorWithRed:68 green:87 blue:169];
}

+ (UIColor *)loginColor {
    return [self colorWithRed:11 green:157 blue:235];
}

+ (UIColor *)facebookColor {
    return [self colorWithRed:60 green:86 blue:152];
}

+ (UIColor *)jkColor {
    return [self colorWithRed:173 green:211 blue:197];
}

+ (UIColor *)toastActivityColor {
    return [self colorWithRed:72 green:206 blue:213];
}

+ (UIColor *)tabbarButtonColor {
    return [self colorWithRed:25 green:167 blue:244];
}

+ (UIColor *)unselectedTabbarButtonColor {
    return [self colorWithRed:167 green:167 blue:167];
}

+ (UIColor *)customCyanColor {
    return [self colorWithRed:126 green:157 blue:176];
}

+ (UIColor *)customTableViewBGColor {
    return [self colorWithRed:241 green:244 blue:246];
}

+ (UIColor *)mainNaviColor {
    return [self colorWithRed:56 green:113 blue:222];
}

+ (UIColor *)mainBGColor {
    return [self colorWithRed:56 green:64 blue:80];
}

+ (UIColor *)gradientColor1{
    return [self colorWithRed:0 green:196 blue:199];
}
+ (UIColor *)gradientColor2{
    return [self colorWithRed:7 green:164 blue:197];
}
+ (UIColor *)gradientColor3{
    return [self colorWithRed:238 green:213 blue:0];
}
+ (UIColor *)gradientColor4{
    return [self colorWithRed:237 green:157 blue:0];
}
+ (UIColor *)gradientColor5{
    return [self colorWithRed:5 green:202 blue:124];
}
+ (UIColor *)gradientColor6{
    return [self colorWithRed:57 green:180 blue:41];
}
+ (UIColor *)gradientColor7{
    return [self colorWithRed:251 green:65 blue:74];
}
+ (UIColor *)gradientColor8{
    return [self colorWithRed:217 green:9 blue:110];
}


+ (UIColor *)gradientColor9{
    return [self colorWithRed:131 green:89 blue:253];
}
+ (UIColor *)gradientColor10{
    return [self colorWithRed:91 green:79 blue:235];
}
+ (UIColor *)gradientColor11{
    return [self colorWithRed:251 green:107 blue:147];
}
+ (UIColor *)gradientColor12{
    return [self colorWithRed:209 green:44 blue:158];
}
+ (UIColor *)gradientColor13{
    return [self colorWithRed:43 green:114 blue:228];
}
+ (UIColor *)gradientColor14{
    return [self colorWithRed:94 green:71 blue:229];
}
+ (UIColor *)gradientColor15{
    return [self colorWithRed:252 green:127 blue:31];
}
+ (UIColor *)gradientColor16 {
    return [self colorWithRed:242 green:36 blue:82];
}


#pragma mark - Private class methods

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

+ (UIColor *)mf_colorWithRed:(NSUInteger)red
                       green:(NSUInteger)green
                        blue:(NSUInteger)blue
                       alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:alpha];
}

@end
