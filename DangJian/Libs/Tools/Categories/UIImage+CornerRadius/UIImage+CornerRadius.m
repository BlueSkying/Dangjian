//
//  UIImage+CornerRadius.m
//  UnionProgarm
//
//  Created by Sakya on 17/2/8.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)
- (UIImage *)imageWithCornerRadius:(CGFloat)radius
                         imageSize:(CGSize)imageSize {
    CGRect rect = (CGRect){0.f, 0.f, imageSize};
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
/// 获取圆形图片
+ (UIImage *)circularClipImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    
    [image drawInRect:rect];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return circleImage;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
