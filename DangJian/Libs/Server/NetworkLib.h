//
//  NetworkLib.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_REQUEST_TIME_OUT 10

typedef NS_OPTIONS(NSInteger, HTTP_METHED) {
    
    HTTP_METHED_POST = 0,
    
    HTTP_METHED_GET
};

@interface NetworkLib : NSObject

+ (void)requestServer:(HTTP_METHED) methed
                  Url:(NSString *)path
            parameter:(NSDictionary *)param
              success:(void(^)(id responseData)) successBlock
               failed:(void(^)(id responseData)) failedBlock;

+ (void)requestServer:(HTTP_METHED) methed
                  Url:(NSString *)path
            parameter:(NSDictionary *)param
               header:(NSDictionary *)headerDictionary
              success:(void(^)(id responseData)) successBlock
               failed:(void(^)(id responseData)) failedBlock;

/**
 包含图片上传的post

 @param path 上传地址
 @param param 上传参数
 @param images 上传图片数组
 @param uploadName 上传图片的key
 */
+ (void)uploadWithPath:(NSString *)path
                 param:(NSDictionary *)param
                images:(NSArray <UIImage *>*)images
       uploadName:(NSString *)uploadName
          successBlock:(void(^)(id result))successBlock
          failureBlock:(void(^)(NSError *errorMsg))failureBlock;



/**
 网络状况监测
 */
+ (void)netReachability;
@end
