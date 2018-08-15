//
//  Helper.h
//  pczd_ios
//
//  Created by Sakya on 16/8/9.
//  Copyright © 2016年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Helper : NSObject

//获得当前的屏幕比例
+(CGFloat)getScreenScale;
+(CGFloat)getCardFont;

/*
 *颜色处理
 */
//16进制转换颜色
+ (UIColor *) colorWithHexString: (NSString *)color;

/*
 *字符串处理
 */
//删除字符串的空格
+(NSString *)deleteSpaceWithString:(NSString *)content;
#pragma mark --网址转码 utf－8
+(NSString *)stringTransformCoding:(NSString *)string;
//字符串解密base64
+ (NSString *)textFromBase64String:(NSString *)base64;
//字符串加密
+ (NSString *)base64StringFromText:(NSString *)text;
/**MD5加密*/
+(NSString *)md5:(NSString *)str;
//判断是合法手机号
+ (BOOL)valiMobile:(NSString *)mobile;
//判断有无汉字
+ (BOOL)isChinese;

/**
 身份证有效性
 */
+ (BOOL)simpleVerifyIdentityCardNum:(NSString *)cardNum;

/*
 *文本自适应
 */
//获取文本的尺寸
+(CGSize)markGetAuthenticSize:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)size;
//通过文本大小获取文本宽度大小
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;
// textStr 富文本的行高
+ (CGFloat)calculateLabelighWithText:(NSString *)textStr withMaxSize:(CGSize)maxSize withFont:(CGFloat)font withSpaceRH:(CGFloat)spaceRH;



/*
 *图片处理
 */
// *  将图片存入沙盒
+ (NSURL *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
//图片压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
//保存数据
+ (NSString *)saveData:(NSData *)data withSuffixName:(NSString *)suffixName;
/**保存文件策略*/
+ (void)writeToDocumentWithData:(NSData* )data name:(NSString* )fileName;
/**读取文件*/
+ (NSData *)readDataFileName:(NSString *)fileName;

/**
 图片尺寸计算
 */



/*
 *时间转换
 */
//字符串转换为时间戳
+(double)changeDateTotimeValWith:(NSString *)dateStr withTimeType:(NSInteger )timeType;
//时间戳转化为时间
+(NSString *)changeTimeToDetailcurrentDateStampTime:(double)stampTime WithTimeType:(NSInteger )type;
//获取当前时间
+ (NSString *)getTodayDate;

/*
 *数据处理
 */
//字典异常值处理
+ (void)setObject:(id)value forKey:(NSString *)key inDic:(NSMutableDictionary *)dic;
//需要删除key值的字典
+ (void)setUnObject:(id)value forUnKey:(NSString *)key inDictionary:(NSMutableDictionary *)dictionary;

//数组排序
+(NSMutableArray *)changeOrderWithMutableArray:(NSMutableArray *)getArray WithKey:(NSString *)key withAscendingOrder:(BOOL)select;






//地址数组转为字符串
+ (NSString *)stringWithPathArray:(NSArray *)array withSpecialString:(NSString *)string;


// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController;
+ (UIViewController*)topViewController;
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
//获取当前屏幕显示的viewcontroller
+ (UIViewController *)superViewControllerWithView:(UIView *)view;

//只判断是否大于0的改变
+(BOOL)judgeDataChangeWithBaseData:(NSInteger)baseData newData:(NSInteger)newData;


//判断两个数组是否相同
+ (BOOL)isSameArray:(NSMutableArray *)theArray WithanotherArray:(NSMutableArray *)anotherArray;



/*
 *清理缓存
 *
 */
+(void)clearTheAppCache;

/**
 * 键盘输入金额控制
 */
+ (BOOL)limitPayMoneyDot:(UITextField *)textField
 ChangeCharactersInRange:(NSRange)range
       replacementString:(NSString *)string
              integerBits:(int)integerBits
             decimalBits:(int)decimalBits;

/**搜索框背景颜色*/
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;



/**可选位置的圆角度*/
+ (void)roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii addView:(UIView *)addView;
/**
 设置控件的阴影加圆角度
 needMaskToBounce 是否需要masksToBounds ＝ Yes的
 @param cornerRadius 圆角度
 @param opacity //阴影透明度，默认0
 @param offset shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
 @param shadowRadius //阴影半径，默认3
 @param addView 需要添加的父视图
 */
+ (void)cornerRadius:(CGFloat)cornerRadius
    needMaskToBounce:(BOOL)needMaskToBounce
       shadowOpacity:(CGFloat)opacity
              offset:(CGSize)offset
        shadowRadius:(CGFloat)shadowRadius
             addView:(UIView *)addView;

/**
 画虚线

 @param lineWidth 线宽度
 @param strokeColor 颜色
 @param shapePath 路径  常见方式
 CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
 CGPathMoveToPoint(dotteShapePath, NULL, 0,CGRectGetMaxY(self.frame) );
 CGPathAddLineToPoint(dotteShapePath, NULL, CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
 @param addView 添加视图
 */
+ (void)drawShapeLayerLineWidth:(CGFloat)lineWidth
                    strokeColor:(UIColor *)strokeColor
                      shapePath:(CGMutablePathRef)shapePath
                        addView:(UIView *)addView;


/**
 字符串转时间戳项目中用到

 @param dateString 日期字符串
 */
+ (NSTimeInterval)timeIntervalWithString:(NSString *)dateString;

@end
