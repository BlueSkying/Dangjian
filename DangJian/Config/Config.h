//
//  Config.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#ifndef Config_h
#define Config_h


//http://www.cocoachina.com/bbs/read.php?tid-332174-page-2.html  Alipay warning

//设备屏幕尺寸 scale
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

//判断设备系统
//
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
//
//****设备类型判断********//
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IsIpad [[UIDevice currentDevice]respondsToSelector:@selector(userInterfaceIdiom)]&&[[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//define modulus4 0.85
//#define modulus5 1
//#define modulus6 1.17
//#define modulus6Plus 1.29
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2000), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2209), [[UIScreen mainScreen] currentMode].size) : NO)

//屏幕的适配
#define SKScaleFrom6(x)  [Helper getScreenScale] * x
//不同设备的屏幕比例  以5s为准
//适配字体
#define SKXScreenScale [[UIScreen mainScreen] bounds].size.width/320.0
//适配宽
#define SKXFrom6(x) ([[UIScreen mainScreen] bounds].size.width/320.0 *x)


//颜色统一 color
//系统红色
#define Color_system_red [Helper colorWithHexString:@"#ff0000"]
//系统导航条渐变颜色颜色
#define Color_systemNav_red_bottom [Helper colorWithHexString:@"#ff0000"]
#define Color_systemNav_red_top [Helper colorWithHexString:@"#f05a24"]

//系统背景颜色
#define SystemGrayBackgroundColor [Helper colorWithHexString:@"#f5f5f5"]
//分割线颜色
#define SystemGraySeparatedLineColor [Helper colorWithHexString:@"#e6e6e6"]
//重新定义 渐淡
#define Color_0 [Helper colorWithHexString:@"#000000"]
#define Color_3 [Helper colorWithHexString:@"#333333"]
#define Color_6 [Helper colorWithHexString:@"#666666"]
#define COLOR_STANDARD_7 [Helper colorWithHexString:@"#777777"]
#define Color_8 [Helper colorWithHexString:@"#888888"]
#define Color_9 [Helper colorWithHexString:@"#999999"]
#define Color_c [Helper colorWithHexString:@"#cccccc"]


//cell time color
#define Color_gray_d [Helper colorWithHexString:@"#b7bdd2"]
//textField边框颜色
#define Color_textField_border [Helper colorWithHexString:@"#e3e3e3"]


#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]




//字号统一
/*
 *常用字体大小
 */
#define FONT_11  [UIFont systemFontOfSize:11]

#define FONT_12  [UIFont systemFontOfSize:12]  //20
#define FONT_15    [UIFont systemFontOfSize:15]  //22
#define FONT_16      [UIFont systemFontOfSize:16]  //28
#define FONT_17        [UIFont systemFontOfSize:17]  //32
#define FONT_19        [UIFont systemFontOfSize:19]  //34
#define FONT_20        [UIFont systemFontOfSize:20]  //36

/*
 * FontScale
 */
#define FontScale_11  [UIFont systemFontOfSize:SKXFrom6(11)]  

#define FontScale_12  [UIFont systemFontOfSize:SKXFrom6(12)]  //20
#define FontScale_13  [UIFont systemFontOfSize:SKXFrom6(13)]  //20
#define FontScale_14  [UIFont systemFontOfSize:SKXFrom6(14)]  //20
#define FontScale_15    [UIFont systemFontOfSize:SKXFrom6(15)]  //22
#define FontScale_16      [UIFont systemFontOfSize:SKXFrom6(16)]  //28
#define FontScale_17        [UIFont systemFontOfSize:SKXFrom6(17)]  //32
#define FontScale_19         [UIFont systemFontOfSize:SKXFrom6(19)]  //34

//定义的常量
//右箭头的大小 13 * 13

//常用宏定义
#define MyDefaults [NSUserDefaults standardUserDefaults]
#define MyNotification [NSNotificationCenter defaultCenter]

/**************************党务日历**************************/
/**view灰色背景颜色*/
#define THEME_BACKCOLOR HexRGB(0xeeeeee)
#define color_yellow HexRGB(0xeac427)
/**棕色文字颜色*/
#define Color_brown HexRGB(0xcb6327)
/**浅灰色按钮背景*/
#define Color_lightGray HexRGB(0xc1c1c1)


/**控件Button蓝色*/
#define BLUE_BUTTON_TEXTCOLOR HexRGB(0x0078d8)
/**header字体深灰色*/
#define DARK_GRAY HexRGB(0x999999)
/**绿色*/
#define COLOR_LIGHTBLUE RGB(29, 192, 33)
/**黑色*/
#define TITLE_BLACK_TEXTCOLOR HexRGB(0x000000)

/**淡黑色字体颜色*/
#define LIGHT_BLACK_TEXTCOLOR HexRGB(0x666666)

/**************************end**************************/


//配置全局输出日志 log
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

//断言
#define SKNSAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)

/**************************end**************************/
//服务器配置
/**0本地 1测试 2正式*/
#define DebugEnvironmentServer 2


//消除警告的宏
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdocumentation"
//#pragma clang diagnostic pop

//1.parameter '%0' not found in the function declaration
#define NS_SUPPRESS_PARAMETERNOTFOUND_USE(expr)   _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")\
expr\
_Pragma("clang diagnostic pop")\
//2.C-style parameters in Objective-C method declarations is deprecated
#define NS_SUPPRESS_DECLARATIONS_USE(expr) _Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"")\
expr\





#endif /* Config_h */
