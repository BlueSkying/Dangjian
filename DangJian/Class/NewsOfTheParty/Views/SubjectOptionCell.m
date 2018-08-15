//
//  SubjectOptionCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SubjectOptionCell.h"


static CGFloat const ImageViewSpaceX = 10.0f;

@interface SubjectOptionCell ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation SubjectOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self initCustomView];
        
    }
    return self;
}

- (void)initCustomView {
    
    // 创建一个空view 代表上一个view
    __block UIImageView *lastView = nil;
    // 间距为10

    for (NSInteger i = 0; i < 2; i ++) {
        
        UIImageView *itemImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:itemImageView];
        itemImageView.tag = i;
        [itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastView) {
                // 存在的话宽度与上一个宽度相同
                make.width.equalTo(lastView);
            } else {
                make.width.mas_equalTo((kScreen_Width - 3* ImageViewSpaceX)/2);
            }
            if (i == 0) {
                make.left.offset(ImageViewSpaceX);
            } else {
                // 二： 不是第一列时 添加左侧与上个view左侧约束
                make.left.mas_equalTo(lastView.mas_right).offset(ImageViewSpaceX);
            }
            
            make.top.offset(5);
            make.bottom.offset(-5);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
        itemImageView.userInteractionEnabled = YES;
        tapGesture.view.tag = i;
        [itemImageView addGestureRecognizer:tapGesture];
        UILabel *titleLabel = [[UILabel alloc] init];
        [itemImageView addSubview:titleLabel];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = FontScale_16;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(itemImageView.mas_centerX);
            make.centerY.mas_equalTo(itemImageView.mas_centerY);
        }];
// 每次循环结束 此次的View为下次约束的基准
        [self.imageArray addObject:itemImageView];
        lastView = itemImageView;
    }
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (void)setSubjectArray:(NSArray<NSDictionary *> *)subjectArray {
    
    _subjectArray = subjectArray;
   
    for (NSInteger i = 0; i < subjectArray.count; i ++) {
        NSDictionary *tmpDict = subjectArray[i];
        UIImageView *imageView = self.imageArray[i];
        imageView.image = [UIImage imageNamed:[tmpDict objectForKey:@"imageName"]];
        [imageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
//            if ([obj isKindOfClass:[UILabel class]]) {
//                ((UILabel *)obj).text = [tmpDict objectForKey:@"title"];
//            }
        }];
    }
    
}
#pragma mark - action
- (void)tapGestureDetected:(UITapGestureRecognizer *)sender {
    
    NSInteger index = sender.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(subjectCellTapGestureDetectedIndex:)]) {
        [self.delegate subjectCellTapGestureDetectedIndex:index];
    }
    
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
