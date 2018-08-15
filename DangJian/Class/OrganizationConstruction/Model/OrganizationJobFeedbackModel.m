//
//  OrganizationJobFeedbackModel.m
//  DangJian
//
//  Created by Sakya on 2017/6/11.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobFeedbackModel.h"
#import "NSString+Util.h"
#import "SKWebImageAutoSize.h"

@implementation JobFeedbackReadModel

- (CGFloat)cellHeight {
    
   
    if (_jobFeedbackReadType == OrganizationJobFeedbackReadPictureType) {
        //计算带图片的高度
        NSURL *imageURL = [NSURL URLWithString:_imageUrl];
       __block CGFloat cellHeight = [self getCellHeight] + 20;
        _cellImageHeight = ceil([SKWebImageAutoSize sk_imageHeightForURL:imageURL layoutWidth:kScreen_Width - 30 estimateHeight:230]);
        _cellHeight = _cellImageHeight + cellHeight;
    } else {
//        只有文字的高度
        CGFloat cellHeight = [self getCellHeight];
        cellHeight += 20;
        _cellHeight = ceil(cellHeight);
    }
    return _cellHeight;
}

- (CGFloat)getCellHeight {
    
    
    CGFloat height = [_content boundingHeightWithSize:CGSizeMake(kScreen_Width - 30, CGFLOAT_MAX) font:FONT_16 paragraphStyle:self.paragraphStyle];
    //计算内容size
    return height;
}
- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        CGFloat labelWidth;
        if (_jobFeedbackReadType == OrganizationJobFeedbackReadPictureType) {
            labelWidth = [@"测试"  widthWithFont:FONT_15 constrainedToHeight:30];
            
        } else {
            labelWidth = [@"测试"  widthWithFont:FONT_15 constrainedToHeight:30];
        }
        paragraphStyle.firstLineHeadIndent = labelWidth;//整体缩进(首行除外)
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5.0f;
        _paragraphStyle = paragraphStyle;
    }
    return _paragraphStyle;
}


@end

@implementation JobFeedbackCommitModel

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        NSArray * dataArray =
        @[@[@{@"title"             :@"活动图片:",
              @"placeholder"       :@"可添加1-2张图片）",
              @"submitKey"         :@"image1",
              @"content"           :@"content" },
            @{@"title"             :@"图一描述:",
              @"placeholder"       :@"请输入图片描述（255字以内）",
              @"submitKey"         :@"desc1",
              @"content"           :@"content" },
            @{@"title"             :@"图二描述",
              @"placeholder"       :@"请输入图片描述（255字以内）",
              @"submitKey"         :@"desc2",
              @"content"           :@"content" }],
          @[ @{@"title"             :@"活动时间:",
               @"placeholder"       :@"请选择活动时间",
               @"submitKey"         :@"activityDate",
               @"content"           :@"content" },
             @{@"title"             :@"活动主题:",
               @"placeholder"       :@"请输入活动主题（50字以内）",
               @"submitKey"         :@"subject",
               @"content"           :@"content" },
             @{@"title"             :@"开展活动及事项详细描述:",
               @"placeholder"       :@"请输入开展活动及事项详细描述...(1000字以内)",
               @"submitKey"         :@"content",
               @"content"           :@"content" }]];
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
    }
    return _dataArray;
}
- (NSMutableArray <UIImage *>*)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end

@implementation OrganizationJobFeedbackModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"feedbackId":@"id"};
}
+ (NSDictionary*)mj_objectClassInArray {
    
    return @{@"list":@"OrganizationJobFeedbackModel"};
}
- (void)setImage1:(NSString *)image1 {
    if (image1 && image1.length > 0) {
        _image1 = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,image1];
    }
}
- (void)setImage2:(NSString *)image2 {
    if (image2 && image2.length > 0) {
        _image2 = [NSString stringWithFormat:@"%@%@",InterfaceIPAddress,image2];
    }
}


- (void)jobFeedbackMine:(BOOL)mine
                success:(void(^)(OrganizationJobFeedbackModel *result)) successBlock
                 failed:(void(^)(id error)) failedBlock {
    
    if (self.pageNo == 0)  [self.listArray removeAllObjects];
    self.pageNo ++;
    __weak typeof(self) weakSelf = self;
    [InterfaceManager jobFeedbackListPageNo:self.pageNo mine:mine success:^(id result) {
        OrganizationJobFeedbackModel *jobFeedbackVo;
        if ([[result objectForKey:@"status"] integerValue] == 1) {
            
            jobFeedbackVo = [OrganizationJobFeedbackModel mj_objectWithKeyValues:[result objectForKey:@"data"]];
            [weakSelf.listArray addObjectsFromArray:jobFeedbackVo.list];;
            jobFeedbackVo.listArray = weakSelf.listArray;
            DDLogInfo(@"%@",jobFeedbackVo);
        }
        successBlock(jobFeedbackVo);
    } failed:^(id error) {
        failedBlock(error);
    }];
    
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _listArray;
}
@end
