//
//  SKScrollViewCell.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKScrollViewCell.h"
#import <SDCycleScrollView.h>

@interface SKScrollViewCell ()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end

@implementation SKScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

#pragma mark -- setter
- (void)setUrlArr:(NSArray *)urlArr {
    _urlArr = urlArr;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *url in _urlArr) {
        [arr addObject:url];
    }
    _cycleScrollView.imageURLStringsGroup = [arr copy];
    _cycleScrollView.currentPageDotColor = Color_system_red;
    
}

-(void)setDataArray:(NSArray *)dataArray {
    
    _dataArray = dataArray;
}

- (void)creatUI {
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, 173) imageURLStringsGroup:nil];
    _cycleScrollView.delegate =self;
    //_cycleScrollView.currentPageDotColor = YellowBG;
    _cycleScrollView.pageDotColor = [UIColor whiteColor];
    //    是否自动滚动
    _cycleScrollView.autoScroll = YES;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"banner_placeholder_icon"];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_cycleScrollView];
    
    //在底部添加按钮
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but setFrame:CGRectMake(20, _cycleScrollView.frame.size.height-50, kScreen_Width-40, 40)];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [but setTitle:@"在此输入查询的词" forState:UIControlStateNormal];
    //[self.contentView addSubview:but];
}

- (void)setHeight:(CGFloat)height
{
    CGFloat K_With = [UIScreen mainScreen].bounds.size.width;
    _height = height;
    _cycleScrollView.frame = CGRectMake(0, 0, K_With, _height);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"%ld", (long)index);
    NSString *targetUrl ;
    if (self.dataArray.count > index) targetUrl = self.dataArray[index];
    !self.block ? :self.block(_dataArray[index]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sk_scrollViewDidSelectItemAtIndex:)]) {
        [self.delegate sk_scrollViewDidSelectItemAtIndex:index];
    }

}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (void)search {
    !self.searchBlock ? :self.searchBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
