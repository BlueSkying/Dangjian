//
//  NSString+Util.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/22.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Util)
@property (readonly) BOOL hasValue;
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

+ (NSString *)reverseString:(NSString *)strSrc;

// 计算NSMutableAttributedString文字高度，可以处理计算带行间距的
- (CGFloat)boundingHeightWithSize:(CGSize)size font:(UIFont*)font;

- (CGFloat)boundingHeightWithSize:(CGSize)size font:(UIFont*)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
//竖排文字
- (NSString *)verticalString;

@end
