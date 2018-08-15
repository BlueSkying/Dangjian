//
//  OrganizationArchCollectionCell.m
//  DangJian
//
//  Created by Sakya on 2017/6/16.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OrganizationArchCollectionCell.h"
#import "NSString+Util.h"


@interface OrganizationArchItemCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backView;
@end
@implementation OrganizationArchItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initCustomView];
    }
    
    return self;
}
- (void)initCustomView {
    
    CALayer *horizontalLayer = [CALayer layer];
    [horizontalLayer setBackgroundColor:Color_c.CGColor];
    [horizontalLayer setFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - 0.25, 0, 0.5, 30)];
    [self.contentView.layer addSublayer:horizontalLayer];
    
    UIView *titleBackView = [[UIView alloc] init];
    [self.contentView addSubview:titleBackView];
    titleBackView.backgroundColor = [UIColor whiteColor];
    titleBackView.frame = CGRectMake(0, 30, 40, 280);
    titleBackView.layer.cornerRadius = ControlsCornerRadius;
    titleBackView.layer.borderWidth = 0.5f;
    titleBackView.layer.borderColor = Color_c.CGColor;
    titleBackView.layer.masksToBounds = YES;
    _backView = titleBackView;
    
    UILabel *titleLabel =
    [SKBuildKit labelWithBackgroundColor:[UIColor clearColor]
                               textColor:Color_3
                            textAligment:NSTextAlignmentCenter
                           numberOfLines:0
                                    text:nil
                                    font:FONT_16];
    [titleBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(5);
        make.top.offset(5);
        make.width.offset(30);
//        make.bottom.lessThanOrEqualTo(@-5);
        make.bottom.offset(-5);
    }];
    _titleLabel = titleLabel;
}
@end

static NSString *CellIdentifier = @"OrganizationID";
@interface OrganizationArchCollectionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation OrganizationArchCollectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = SystemGrayBackgroundColor;
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    
    CALayer *vLayer = [CALayer layer];
    [vLayer setBackgroundColor:Color_c.CGColor];
    [vLayer setFrame:CGRectMake(kScreen_Width/2 - 0.25, 0, 0.5, 40)];
    [self.contentView.layer addSublayer:vLayer];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //该方法也可以设置itemSize
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize =CGSizeMake(40, 330);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = ({
        UICollectionView *collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //设置UICollectionView的尺寸
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.frame = CGRectMake(20, 40, kScreen_Width - 40, 370 - 40);
        // 设置数据源,展示数据
        collectionView.dataSource = self;
        //设置代理,监听
        collectionView.delegate = self;
        [collectionView registerClass:[OrganizationArchItemCell class] forCellWithReuseIdentifier:CellIdentifier];
        /* 设置UICollectionView的属性 */
        //设置滚动条
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView;
    });
    _collectionView = collectionView;
    [self.contentView addSubview:collectionView];

    collectionView.layer.borderWidth = 0.5f;
    collectionView.layer.borderColor = Color_c.CGColor;
    
    
}

#pragma mark -- collectiondatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _memberArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationalStructureVo *memberVo;
    if (_memberArray.count > indexPath.row) {
        memberVo = _memberArray[indexPath.row];
    }
    OrganizationArchItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = memberVo.name ? [memberVo.name verticalString] : nil;
    return cell;
}
//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizationArchItemCell* cell = (OrganizationArchItemCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backView.backgroundColor = Color_system_red;
    cell.titleLabel.textColor = [UIColor whiteColor];
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    OrganizationArchItemCell* cell = (OrganizationArchItemCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backView.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.textColor = Color_3;
}



- (void)setMemberArray:(NSArray *)memberArray {
    _memberArray = memberArray;
    [_collectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(archCollectionCellSelectedIndexPath:)]) {
        [_delegate archCollectionCellSelectedIndexPath:indexPath];
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
