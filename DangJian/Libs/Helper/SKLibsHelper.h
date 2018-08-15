//
//  SKLibsHelper.h
//  DangJian
//
//  Created by Sakya on 17/5/16.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 需要依赖库的helper
 */
@interface SKLibsHelper : NSObject

/**
 ***计算网络图片的长宽
 */
+(CGSize)downloadImageSizeWithURL:(id)imageURL;

/**
 获取图片的尺寸

 @param imageURL 图片地址
 */
+(CGSize)getURLImageSizeWithURL:(NSURL *)imageURL;
@end
