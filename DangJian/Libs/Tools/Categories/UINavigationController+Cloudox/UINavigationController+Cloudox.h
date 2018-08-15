//
//  UINavigationController+Cloudox.h
//  DangJian
//
//  Created by Sakya on 2017/6/30.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Cloudox) <UINavigationBarDelegate, UINavigationControllerDelegate>
@property (copy, nonatomic) NSString *cloudox;
- (void)setNeedsNavigationBackground:(CGFloat)alpha;
@end
