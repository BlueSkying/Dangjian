//
//  UIImage+CornerRadius.h
//  UnionProgarm
//
//  Created by Sakya on 17/2/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CornerRadius)

- (UIImage *)imageWithCornerRadius:(CGFloat)radius
                         imageSize:(CGSize)imageSize;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// 获取圆形图片
+ (UIImage *)circularClipImage:(UIImage *)image;
@end
