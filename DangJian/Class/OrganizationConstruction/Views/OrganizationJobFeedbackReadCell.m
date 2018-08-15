//
//  OrganizationJobFeedbackReadCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationJobFeedbackReadCell.h"


@interface OrganizationJobFeedbackReadCell ()

/**
 展示图片
 */
@property (nonatomic, strong) UIImageView *feedbackImageView;
/**
 图片描述
 */
@property (nonatomic, strong) UILabel *descirbeLabel;
/**
 图片描述
 */
@property (nonatomic, strong) UILabel *contentLabel;


@end
@implementation OrganizationJobFeedbackReadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.right.offset(-15);
        make.height.offset(10);
    }];
    imageView.contentMode =  UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"organization_jobFeedbackDescribe_placeholder_icon"];
    _feedbackImageView = imageView;
    
    UILabel *descirbeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descirbeLabel];
    descirbeLabel.numberOfLines = 0;
    [descirbeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
        make.right.offset(-15);
        make.bottom.offset(-10);
    }];
    _descirbeLabel = descirbeLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.right.offset(-15);
        make.bottom.offset(-10);
    }];
    contentLabel.numberOfLines = 0;
    _contentLabel = contentLabel;
}
- (void)bindDataJobFeedbackReadVo:(JobFeedbackReadModel *)jobFeedbackReadVo imageLoadSuccessBlock:(void(^)(UIImage *image))loadSuccessBlock {
    
    //根据是显示图片还是工作反馈的conten内容
    if (jobFeedbackReadVo.jobFeedbackReadType == OrganizationJobFeedbackReadPictureType) {
        _contentLabel.hidden = YES;
        _descirbeLabel.hidden = NO;
        _feedbackImageView.hidden = NO;
        [_feedbackImageView sd_setImageWithURL:[NSURL URLWithString:jobFeedbackReadVo.imageUrl] placeholderImage:[UIImage imageNamed:@"organization_jobFeedbackDescribe_placeholder_icon"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
            loadSuccessBlock(image);
        }];
        _descirbeLabel.attributedText = [SKBuildKit attributedStringWithString:jobFeedbackReadVo.content paragraphStyle:jobFeedbackReadVo.paragraphStyle textColor:Color_6 textFont:FONT_15];
        //更新约束
        [self updateReadPictureConstraintsReadVo:jobFeedbackReadVo];

        
    } else if (jobFeedbackReadVo.jobFeedbackReadType == OrganizationJobFeedbackReadContenrType) {
       
        _contentLabel.hidden = NO;
        _descirbeLabel.hidden = YES;
        _feedbackImageView.hidden = YES;
        _contentLabel.attributedText = [SKBuildKit attributedStringWithString:jobFeedbackReadVo.content paragraphStyle:jobFeedbackReadVo.paragraphStyle textColor:Color_3 textFont:FONT_16];
        [self updateReadDescribeConstraintsReadVo:jobFeedbackReadVo];
    }
}
- (void)updateReadPictureConstraintsReadVo:(JobFeedbackReadModel *)jobFeedbackReadVo {

//    __weak typeof(self) weakSelf = self;
    [_feedbackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.right.offset(-15);
        make.height.offset(jobFeedbackReadVo.cellImageHeight);
    }];
   

}
- (void)updateReadDescribeConstraintsReadVo:(JobFeedbackReadModel *)jobFeedbackReadVo {
    
    [_feedbackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.right.offset(-15);
        make.height.offset(10);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
