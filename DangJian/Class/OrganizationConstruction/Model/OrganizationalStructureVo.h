//
//  OrganizationalStructureVo.h
//  DangJian
//
//  Created by Sakya on 17/5/31.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSInteger, OrganizationLocationHierarchy) {
    
    //党组
    OrganizationLocationHierarchyGroup = 0,
//    党会
    OrganizationLocationHierarchyMeeting = 1,
//    党支部
    OrganizationLocationHierarchyBranch = 2,
};

@interface OrganizationalMemberVo : NSObject

/**
 账号
 */
@property (nonatomic, copy) NSString *account;

/**
 党内职务
 */
@property (nonatomic, copy) NSString *duty;
/**
 头像
 */
@property (nonatomic, copy) NSString *image;
/**
 昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 用户id
 */
@property (nonatomic, copy) NSString *userId;
/**
 少数民族
 */
@property (nonatomic, copy) NSString *min;

/**
 党员总数
 */
@property (nonatomic, copy) NSString *all;

/**
 汉族
 */
@property (nonatomic, copy) NSString *han;

/**
 男党员总数
 */
@property (nonatomic, copy) NSString *man;

/**
 女党员总数
 */
@property (nonatomic, copy) NSString *woman;

/**
 35岁及以下
 */
@property (nonatomic, copy) NSString *age;
/**
 大专及以上
 */
@property (nonatomic, copy) NSString *edu;
/**
 换届时间
 */
@property (nonatomic, copy) NSString *changeDate;

@end



@interface OrganizationalStructureVo : NSObject

@property (nonatomic, strong) NSArray *list;
/**
 页码
 */
@property (nonatomic, assign) NSInteger pageNo;
/**
 每页条数
 */
@property (nonatomic, assign) NSInteger pageSize;
/**
 全部页码
 */
@property (nonatomic, assign) NSInteger totalPage;

//增加的为了添加所有数据
@property (nonatomic, strong) NSMutableArray *totalArray;


/**组织名称*/
@property (nonatomic, copy) NSString *name;
/**组织名称*/
@property (nonatomic, copy) NSString *orgId;
/**组织级别*/
@property (nonatomic, copy) NSString *level;
/**子级组织*/
@property (nonatomic, strong) NSArray *childrenVo;
/**
 换届时间
 */
@property (nonatomic, copy) NSString *changeDate;
/**
 组织级别
 */
@property (nonatomic, assign) OrganizationLocationHierarchy locationHierarchy;
/**
 组织级别   0 党组 1机关党委 2党支部
 */
@property (nonatomic, copy) NSString *orgLevel;

/**
 组织框架

 */
+ (void)organizationListSuccess:(void(^)(OrganizationalStructureVo *result)) successBlock;


/**
 组织党员统计

 @param orgId 组织id

 */
- (void)organizationMemberCountOrgId:(NSString *)orgId
                             Success:(void(^)(OrganizationalMemberVo *result)) successBlock
                              failed:(void(^)(id error)) failedBlock;


/**
 组织成员详情
 @param orgId 组织id
 @param isHeader 是否是刷新的
 */
- (void)organizationUserLisyIsHeader:(BOOL)isHeader
                               orgId:(NSString *)orgId
                          Success:(void(^)(OrganizationalStructureVo *result)) successBlock
                           failed:(void(^)(id error)) failedBlock;

@end
