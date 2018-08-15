//
//  Helper.m
//  pczd_ios
//
//  Created by Sakya on 16/8/9.
//  Copyright © 2016年 Sakya. All rights reserved.
//

#import "Helper.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>


#define     LocalStr_None           @""
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation Helper
//屏幕适配
+(CGFloat)getScreenScale {
    if (iPhone6) {
        return 1.17;
    } else if (iPhone6Plus) {
        return 1.29;
    } else if (iPhone4s) {
        return 0.85;
    } else {
        return 1;
    }
}
//字体大小适配
+(CGFloat)getCardFont {
    if (iPhone6Plus||iPhone6s||iPhone6sPlus) {
        return 1.4;
    } else if (iPhone6) {
        return 1.2;
    } else {
        return 1;
    }
}

//html和16进制颜色转换
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
//去处空格和回车符
+(NSString *)deleteSpaceWithString:(NSString *)content {
    
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return content;
}
/**
 *  将图片存入沙盒
 *
 *  @param currentImage 图片
 *  @param imageName    名称
 *
 *  @return 返回路径
 */
+ (NSURL *) saveImage:(UIImage *)currentImage withName:(NSString *)imageName{
    
    NSData *imageData;
    currentImage = [Helper imageWithImage:currentImage scaledToSize:CGSizeMake(280, 280/currentImage.size.width*currentImage.size.height)];
    if (UIImagePNGRepresentation(currentImage) == nil) {
        imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    } else {
        imageData = UIImagePNGRepresentation(currentImage);
    }
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    BOOL isOk =  [imageData writeToFile:fullPath atomically:NO];
    if (isOk) {
        return  [NSURL fileURLWithPath:fullPath];
    }else{
        return nil;
    }
}
/**
 *  将文件存入沙盒
 *
 *  @param data 文件
 *  @param suffixName    文件后缀名
 *
 *  @return  NSURL返回路径
 */
+ (NSString *) saveData:(NSData *)data withSuffixName:(NSString *)suffixName{
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:suffixName];
    // 将图片写入文件
    BOOL isOk =  [data writeToFile:fullPath atomically:NO];

    if (isOk) {
        return  fullPath;
    } else {
        return nil;
    }
}
//上传字典为空时
+ (void)setObject:(id)value forKey:(NSString *)key inDic:(NSMutableDictionary *)dic {
    if (key == nil || [key isEqual:[NSNull null]] || !key) {
        return;
    }
    if (value == nil || [value isEqual:[NSNull null]] || !value) {
        [dic setObject:@"" forKey:key];

    } else {
        [dic setObject:value forKey:key];
    }
}
//需要删除key值 或value值的字典
+ (void)setUnObject:(id)value forUnKey:(NSString *)key inDictionary:(NSMutableDictionary *)dictionary
{
    if (value == nil || [value isEqual:[NSNull null]] || !value) {
        value = @"";
        //        判断如果字典总存在这个key 则删除这个key
        if (key&&key != nil&&[dictionary.allKeys containsObject:key]) {
            [dictionary removeObjectForKey:key];
        }
    } else if(key == nil || [key isEqual:[NSNull null]] || !key) {
        value = @"";
    } else {
        [dictionary setObject:value forKey:key];
    }
}

+(double)changeDateTotimeValWith:(NSString *)dateStr withTimeType:(NSInteger )timeType {
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    
    if (timeType == 0) {
        
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
        
    } else if (timeType == 1) {
        
        //        2016年8月10日 下午3:14:57
        
        if ([dateStr rangeOfString:@"上午"].location !=NSNotFound || [dateStr rangeOfString:@"下午"].location !=NSNotFound) {
            
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm:ss"];
            
            if ([dateStr rangeOfString:@"上午"].location !=NSNotFound) {
                
                NSArray *timeArray = [dateStr componentsSeparatedByString:@"上午"];
                
                dateStr = [NSString stringWithFormat:@"%@%@",timeArray[0],timeArray[1]];
            }
            else
            {
                NSArray *timeArray = [dateStr componentsSeparatedByString:@"下午"];
                
                dateStr = [NSString stringWithFormat:@"%@%@",timeArray[0],timeArray[1]];
            }
        } else {
            
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            
        }
        
    }
    //------------将字符串按formatter转成nsdate
    
    NSDate *newDate = [dateFormatter dateFromString:dateStr];
    
    //    时间转换时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[newDate timeIntervalSince1970]];
    return [timeSp doubleValue];
    
}
//时间戳转化为时间
+(NSString *)changeTimeToDetailcurrentDateStampTime:(double)stampTime WithTimeType:(NSInteger )type
{
    
    NSString *stampTimeStr = [NSString stringWithFormat:@"%f",stampTime];
    
    
    if ([stampTimeStr length] > 10) {
        stampTime = [[stampTimeStr substringWithRange:NSMakeRange(0, 10)] doubleValue];
        
    }
    
    
    NSTimeInterval time= stampTime ;
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    DDLogInfo(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    if (type == 0) {
        [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    }
    else if (type == 1)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (type == 2)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else if (type == 3)
    {
        [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    }
    else if (type == 4)
    {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    else if (type == 5)
    {
        [dateFormatter setDateFormat:@"hh"];
    }
    else if (type == 6)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else if (type == 7)
    {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
    
    
}

//获取当前时间
+ (NSString *)getTodayDate {
    
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:3 * 60 * 60 + 30 * 60];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    return [formatter stringFromDate:now];
}
//字符串加密

+ (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [self base64EncodedStringFrom:data];
    }
    else {
        return LocalStr_None;
    }
}

//字符串解密
+ (NSString *)textFromBase64String:(NSString *)base64 {
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [self dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}


/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data {
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

/***/
+(NSString *)md5:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


#pragma mark --网址转码
+(NSString *)stringTransformCoding:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return string;
    }
    return string;
}
//压缩图片方法1.
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
//2.
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


//根据特殊字符串数组转为字符串
+ (NSString *)stringWithPathArray:(NSArray *)array withSpecialString:(NSString *)string {
    
    //    字符串合并
    if (array == nil || array.count == 0) {
        return nil;
    }
    NSMutableString *allPathStr = [NSMutableString string] ;
    for (NSInteger i = 0; i < array.count; i ++ ) {
        NSString *str = array[i];
        if (i != array.count - 1) {
            [allPathStr appendString:[NSString stringWithFormat:@"%@%@",str,string]];
        }
        else
        {
            [allPathStr appendString:[NSString stringWithFormat:@"%@",str]];
        }
    }
    return [Helper deleteSpaceWithString:allPathStr];
}

+ (BOOL)valiMobile:(NSString *)mobile {
    if (mobile.length != 11)
    {
        return NO;
    }else
    {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        /**
         * 更新的手机号码
         */
        NSString *special_NUM = @"1[3|4|5|7|8][0-9]\\d{8}";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", special_NUM];
        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3 || isMatch4) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}
+(NSMutableArray *)changeOrderWithMutableArray:(NSMutableArray *)getArray WithKey:(NSString *)key withAscendingOrder:(BOOL)select
{
    //    yes升序    no降序大到小
    
    NSSortDescriptor *reversedSorter = [NSSortDescriptor sortDescriptorWithKey:key ascending:select];
    
    NSMutableArray *descriptors = [NSMutableArray arrayWithObjects:&reversedSorter count:1];
    
    NSArray *middleArray = [getArray sortedArrayUsingDescriptors:descriptors];
    
    NSMutableArray *sendArray = [NSMutableArray arrayWithArray:middleArray];
    return sendArray;
    
}


//获取文本的尺寸
+ (CGSize)markGetAuthenticSize:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)size{
    
    //获取当前那本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    //实际尺寸
    CGSize actualSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return actualSize;
}


//sizeWithAttributes:方法 适用于不换行的情况,宽度不受限制的情况
/// 根据指定文本和字体计算尺寸
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font {
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attrDict];
}

#define GetLabelNormalHeight(height,font,spaceH) (height + (height - [UIFont systemFontOfSize:font].pointSize)*(spaceH>0 ? spaceH : 0.05))
/**
 *@param textStr 富文本的string属性的值
 *@param maxSize 控件所需最大空间，一般高是最大值，如：CGSizeMake(stockNameLabelW, MAXFLOAT)
 *@param font 字体大小
 *@param spaceRH label行距占行高的比例，若没有设置行高，默认值为0.05
 */
+ (CGFloat)calculateLabelighWithText:(NSString *)textStr withMaxSize:(CGSize)maxSize withFont:(CGFloat)font withSpaceRH:(CGFloat)spaceRH {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [textStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return GetLabelNormalHeight(rect.size.height, font, spaceRH);
}

//获取当前视图控制器
#pragma mark -- 获取当前的ViewController
//获取当前屏幕显示的viewcontroller
// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
        //        <span style="font-family: Arial, Helvetica, sans-serif;">//  这方法下面有详解    </span>
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}



//获取最上层的控制器
+ (UIViewController*)topViewController {
    
    return [Helper topViewControllerWithRootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
}
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


//只判断是否大于0的改变
+(BOOL)judgeDataChangeWithBaseData:(NSInteger)baseData newData:(NSInteger)newData
{
    if (baseData != newData ) {
        return YES;
    }
    return NO;
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)superViewControllerWithView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (BOOL)isSameArray:(NSMutableArray *)oldArr WithanotherArray:(NSMutableArray *)newArr {
    bool bol = false;
    
    //创建俩新的数组
    NSMutableArray *theArray = [NSMutableArray arrayWithArray:oldArr];
    NSMutableArray *anotherArray = [NSMutableArray arrayWithArray:newArr];
    
    //对数组1排序。
    [theArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return obj1 > obj2;
    }];
    
    ////上个排序好像不起作用，应采用下面这个
    //    [theArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
    //        return [obj1 localizedStandardCompare: obj2];
    //    }];
    
    //对数组2排序。
    [anotherArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return obj1 > obj2;
    }];
    ////上个排序好像不起作用，应采用下面这个
    //    [anotherArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
    //        return [obj1 localizedStandardCompare: obj2];
    //    }];
    
    if (anotherArray.count == theArray.count) {
        
        bol = true;
        for (int16_t i = 0; i < theArray.count; i++) {
            
            id c1 = [theArray objectAtIndex:i];
            id newc = [anotherArray objectAtIndex:i];
            
            if (![c1 isEqual:newc]) {
                bol = false;
                break;
            }
        }
    }
    
    if (bol) {
        NSLog(@"两个数组的内容相同！");
    } else {
        NSLog(@"两个数组的内容不相同！");
    }
    return bol;
}

//清理缓存
+(void)clearTheAppCache{
    
    //    清空数据库缓存
    
    
//    UserOperation *userInfo = [UserOperation shareInstance];
//    //为每一个用户创建一个文件夹保存表
//    NSString * userFilePath= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:userInfo.phone];
//    // 判断文件夹是否存在，如果不存在，则创建
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    
//    
//    //    包括清理图片缓存
//    //    //1.清空缓存
//    [[SDWebImageManager sharedManager].imageCache clearDisk];
//    [[SDWebImageManager sharedManager].imageCache cleanDisk];
//    //2.取消当前的下载操作
//    [[SDWebImageManager sharedManager] cancelAll];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:userFilePath]) {
//        
//        [fileManager removeItemAtPath:userFilePath error:nil];
//    }
    


    
}

+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//+(float)folderSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    float folderSize;
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            folderSize +=[Helper fileSizeAtPath:absolutePath];
//        }
//        　　　//SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//        return folderSize;
//    }
//    return 0;
//}


+ (BOOL)limitPayMoneyDot:(UITextField *)textField
 ChangeCharactersInRange:(NSRange)range
       replacementString:(NSString *)string
             integerBits:(int)integerBits
             decimalBits:(int)decimalBits {
    
    // 判断是否输入内容，或者用户点击的是键盘的删除按钮
    NSString *myDotNumbers = @"0123456789.\n";
    NSString *myNumbers = @"0123456789\n";
    if (![string isEqualToString:@""]) {
        NSCharacterSet *cs;
        // 小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        // 判断字符串中是否有小数点，并且小数点不在第一位
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        if (dotLocation == NSNotFound && range.location != 0) {
            
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            /* [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers] invertedSet];
            if (range.location >= integerBits) {
                NSLog(@"单笔金额不能超过6位");
                if ([string isEqualToString:@"."] && range.location == integerBits) {
                    return YES;
                }
                return NO;
            }
        }else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers] invertedSet];
            
        }
        // 按cs分离出数组,数组按@""分离出字符串
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (!basicTest) {
            NSLog(@"只能输入数字和小数点");
            return NO;
        }
        
        if (dotLocation != NSNotFound && range.location > dotLocation + decimalBits) {
            NSLog(@"小数点后最多两位");
            return NO;
        }
        //
        if (textField.text.length > decimalBits + integerBits) {
            return NO;
        }
        //判断整数部分以0开头
        if ([textField.text isEqualToString:@"0"] &&
            ![string isEqualToString:@"."]) {
            
            textField.text = string;
            return NO;
            
        }
        
    }
    return YES;
    
}
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (void)writeToDocumentWithData:(NSData* )data name:(NSString* )fileName {
   
    NSString *path = [self filePath:fileName];
    [data writeToFile:path atomically:YES];
}
//获取文件路径
+ (NSString*)filePath:(NSString*)fileName {
    
    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* myDocPath = [myPaths objectAtIndex:0];
    NSString* filePath = [myDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data",fileName]];
    return filePath; 
}
+ (NSData *)readDataFileName:(NSString *)fileName {
    
    NSString *path = [self filePath:fileName];
//    　最后:从文件中读出数据:
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:NULL];
    return data;
}
+ (BOOL)isChinese {
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
+ (BOOL)simpleVerifyIdentityCardNum:(NSString *)cardNum {
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateByRegex:regex2 text:cardNum];
}
#pragma mark - 正则相关
+ (BOOL)isValidateByRegex:(NSString *)regex text:(NSString *)text {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:text];
}

+ (void)roundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii addView:(UIView *)addView {

    if (!addView) return;
    UIBezierPath  *maskPath= [UIBezierPath  bezierPathWithRoundedRect:addView.bounds
                                                    byRoundingCorners:corners          cornerRadii:CGSizeMake(4,4)];
    CAShapeLayer*maskLayer = [[CAShapeLayer  alloc]  init];
    maskLayer.frame = addView.bounds;
    maskLayer.path = maskPath.CGPath;
    addView.layer.mask = maskLayer;
    
}

+ (void)cornerRadius:(CGFloat)cornerRadius
    needMaskToBounce:(BOOL)needMaskToBounce
       shadowOpacity:(CGFloat)opacity
              offset:(CGSize)offset
        shadowRadius:(CGFloat)shadowRadius
             addView:(UIView *)addView {
    
    if (needMaskToBounce) {
        //设置圆角度
        addView.layer.masksToBounds = YES;
        addView.layer.cornerRadius = cornerRadius;
        
        //    设置阴影
        CALayer *subLayer=[CALayer layer];
        CGRect fixframe=addView.layer.frame;
        subLayer.frame=fixframe;
        subLayer.cornerRadius=cornerRadius;
        subLayer.backgroundColor=[Color_9 colorWithAlphaComponent:0.5].CGColor;
        subLayer.shadowColor=Color_9.CGColor;
        subLayer.shadowOffset=offset;
        subLayer.shadowOpacity=opacity;
        subLayer.shadowRadius=shadowRadius;
        [addView.superview.layer insertSublayer:subLayer below:addView.layer];
        
    } else {
        addView.layer.cornerRadius= cornerRadius;
        addView.layer.shadowColor= Color_system_red.CGColor;
        addView.layer.shadowOffset=offset;
        addView.layer.shadowOpacity=opacity;
        addView.layer.shadowRadius=shadowRadius;
    }

}
+ (void)drawShapeLayerLineWidth:(CGFloat)lineWidth
                    strokeColor:(UIColor *)strokeColor
                      shapePath:(CGMutablePathRef)shapePath
                        addView:(UIView *)addView {
    
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    [dotteShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [dotteShapeLayer setStrokeColor:strokeColor.CGColor];
    dotteShapeLayer.lineWidth = lineWidth ;
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    [dotteShapeLayer setPath:shapePath];
    CGPathRelease(shapePath);
    [addView.layer addSublayer:dotteShapeLayer];
    
}
+ (NSTimeInterval)timeIntervalWithString:(NSString *)dateString {
    if (!dateString) return 0;
    
    static NSDateFormatter *formatterGetData;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterGetData = [[NSDateFormatter alloc] init];
        [formatterGetData setDateFormat:@"yyyy/MM-dd HH:mm:ss"];
        [formatterGetData setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *getDate = [formatterGetData dateFromString:dateString];
    NSTimeInterval getTimeIntervla = [getDate timeIntervalSince1970];
    return getTimeIntervla;
}

@end
