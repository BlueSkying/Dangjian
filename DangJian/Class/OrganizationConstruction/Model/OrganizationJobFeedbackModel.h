//
//  OrganizationJobFeedbackModel.h
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, OrganizationJobFeedbackReadType) {
    //图片描述的
    OrganizationJobFeedbackReadPictureType = 0,
    //    反馈内容的
    OrganizationJobFeedbackReadContenrType = 1
    
};

@interface JobFeedbackReadModel : NSObject

@property (nonatomic, assign) OrganizationJobFeedbackReadType  jobFeedbackReadType;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) CGFloat cellImageHeight;
//带有图片的cell 高度
@property (nonatomic, assign) CGFloat cellHeight;

//内容文字风格
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;

@end

@interface JobFeedbackCommitModel : NSObject
//上传时候的字段

/**
 图片1描述 最大值100
 */
@property (nonatomic, copy) NSString *desc1;

/**
 图片2描述 最大值100
 */
@property (nonatomic, copy) NSString *desc2;

/**
 活动时间
 */
@property (nonatomic, copy) NSString *activityDate;
/**
 待办事项ID
 */
@property (nonatomic, copy) NSString *backlogId;

/**
 图片1
 */
@property (nonatomic, strong) UIImage *image1;
/**
 图片2
 */
@property (nonatomic, strong) UIImage *image2;
/**
 活动主题 最大值50
 */
@property (nonatomic, copy) NSString *subject;
/**
 详细描述 最大值1000
 */
@property (nonatomic, copy) NSString *content;

//默认字段
@property (nonatomic, strong) NSMutableArray *dataArray;


// ************* 添加字段
/**
 所有图片数组
 */
@property (nonatomic, strong) NSMutableArray <UIImage *>*images;


@end


@interface OrganizationJobFeedbackModel : NSObject
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


//查询的时候的字段
/**
 活动主题
 */
@property (nonatomic, copy) NSString *subject;

/**
 详细描述
 */
@property (nonatomic, copy) NSString *content;

/**
 图片1组合描述
 */
@property (nonatomic, copy) NSString *description1;
/**
 图片2组合描述
 */
@property (nonatomic, copy) NSString *description2;

/**
 图片1
 */
@property (nonatomic, copy) NSString *image1;

/**
 图片2
 */
@property (nonatomic, copy) NSString *image2;

/**
 反馈id
 */
@property (nonatomic, copy) NSString *feedbackId;
@property (nonatomic, strong) NSArray *list;
/**
 全部列表
 */
@property (nonatomic, strong) NSMutableArray *listArray;

- (void)jobFeedbackMine:(BOOL)mine
                   success:(void(^)(OrganizationJobFeedbackModel *result)) successBlock
                    failed:(void(^)(id error)) failedBlock;


@end
