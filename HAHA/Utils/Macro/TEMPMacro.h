//
//  TEMPMacro.h
//

#ifndef TEMPMacro_h
#define TEMPMacro_h



#define BASE_URL          @"http://120.78.124.36:10010/MRYX/"



#define TEMP_EXTERN extern __attribute__((visibility ("default")))

#define color(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define GODColor(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]


// 宽度
#define  ScreenWidth                             [UIScreen mainScreen].bounds.size.width

// 高度
#define  ScreenHeight                            [UIScreen mainScreen].bounds.size.height

/** 顶部导航栏高度 */
#define NavBarHeight (ScreenHeight >= 812.0 ? 88 : 64)
/** 顶部电源栏高度 */
//#define StatusBarHeight (ScreenHeight >= 812.0 ? 44 : 20)
/** 底部安全距离高度[适配PhoneX底部] */
#define SafeAreaBottomHeight (ScreenHeight >= 812.0 ? 34 : 0)
/** 顶部安全距离高度[适配PhoneX底部] */
#define SafeAreaTopHeight (ScreenHeight >= 812.0 ? 24 : 0)
#define SafeTabBarHeight (CGFloat)(ScreenHeight >= 812.0?(49.0 + 34.0):(49.0))
// 手机屏幕自动适配
#define AUTO_FIT(float) ((ScreenHeight < ScreenWidth ? ScreenHeight : ScreenWidth) / 375.0f * float)

#define  SCREENWIDTH                       [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT                      [UIScreen mainScreen].bounds.size.height
#define  STATUSBARHEIGHT                   [UIApplication sharedApplication].statusBarFrame.size.height
#define  NAVIGATIONBARHEIGHT               self.navigationController.navigationBar.frame.size.height
#define  TABBARHEIGHT                      self.tabBarController.tabBar.frame.size.height
#define  STATUSBARANDNAVIGATIONBARHEIGHT   (STATUSBARHEIGHT + NAVIGATIONBARHEIGHT)


#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_X(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_Y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_POINT(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_WIDTH(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_HEIGHT(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_SIZE(v,w,h)     CGRectMake(X(v), Y(v), w, h)

#endif /* TEMPMacro_h */
