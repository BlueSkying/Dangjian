//
//  OnlineTestQidChoiceView.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestQidChoiceView.h"



//自定义cell
@interface OnlineTestQidChoiceCell ()
/**
 是否高亮
 */
@property (nonatomic, assign) BOOL isHighlighted; //default NO;


@property (nonatomic, strong) UILabel *qidLabel;
@end
@implementation OnlineTestQidChoiceCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
    }
    
    return self;
}
- (void)initCustomView {
    
    UILabel *qidLabel = [[UILabel alloc] init];
    [self.contentView addSubview:qidLabel];
    [qidLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
        
    }];
    qidLabel.textAlignment = NSTextAlignmentCenter;
    qidLabel.font = FONT_15;
    qidLabel.textColor = Color_8;
    qidLabel.layer.cornerRadius = 4.0f;
    qidLabel.backgroundColor = [UIColor whiteColor];
    qidLabel.layer.borderWidth = 1.0f;
    qidLabel.layer.masksToBounds = YES;
    _qidLabel = qidLabel;
    
}

- (void)setIsHighlighted:(BOOL)isHighlighted {
    
    if (isHighlighted) {
        _qidLabel.textColor = Color_system_red;
        _qidLabel.layer.borderColor = Color_system_red.CGColor;
        _qidLabel.backgroundColor = HexRGBAlpha(0xff0000, 0.2);
    } else {
        _qidLabel.textColor = Color_8;
        _qidLabel.layer.borderColor = Color_textField_border.CGColor;
        _qidLabel.backgroundColor = [UIColor whiteColor];
    }
    
}

@end




//底部导航条
@protocol OnlineTestQidChoiceNavBarViewDelegate <NSObject>

@optional
- (void)onlineTestQidChoiceNavBarTitleTapDetected:(UITapGestureRecognizer *)sender;
- (void)onlineTestQidChoiceNavBarButtonClicked:(UIButton *)sender;

@end

@interface OnlineTestQidChoiceNavBarView ()

@property (nonatomic, weak) id<OnlineTestQidChoiceNavBarViewDelegate>delegate;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILabel *browseQidLabel;

@end

@implementation OnlineTestQidChoiceNavBarView

- (instancetype)initWithFrame:(CGRect)frame {

    
    if (self = [super initWithFrame:frame]) {
        
        [self initCustomView];
    }
    return self;
}
- (void)initCustomView {
    
    __weak typeof(self) weakSelf = self;
    
    UIButton *leftButton = [SKBuildKit buttonWithImageName:@"onlineTest_leftArrow_icon" superview:self target:self action:@selector(qidChoiceViewClicked:)];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.mas_equalTo(weakSelf);
        make.width.offset(90);
        
    }];
    leftButton.tag = 0;
    _leftButton = leftButton;
    
    UIButton *rightButton = [SKBuildKit buttonWithImageName:@"onlineTest_rightArrow_icon" superview:self target:self action:@selector(qidChoiceViewClicked:)];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.mas_equalTo(weakSelf);
        make.width.offset(90);
    }];
    rightButton.tag = 1;
    _rightButton = rightButton;
    
    UILabel *qidChoiceLabel = [[UILabel alloc] init];
    [self addSubview:qidChoiceLabel];
    [qidChoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf);
        make.left.mas_equalTo(leftButton.mas_right);
        make.right.mas_equalTo(rightButton.mas_left);
    }];
    qidChoiceLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nabBarTitleTapGestureDetected:)];
    [qidChoiceLabel addGestureRecognizer:tapGesture];
    qidChoiceLabel.userInteractionEnabled = YES;
    _browseQidLabel = qidChoiceLabel;
    
    
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
    [dotteShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [dotteShapeLayer setStrokeColor:Color_c.CGColor];
    
    dotteShapeLayer.lineWidth = 1.0f ;
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    CGPathMoveToPoint(dotteShapePath, NULL, 0,CGRectGetMaxY(self.frame) );
    CGPathAddLineToPoint(dotteShapePath, NULL, CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    
    [dotteShapeLayer setPath:dotteShapePath];
    CGPathRelease(dotteShapePath);
    [self.layer addSublayer:dotteShapeLayer];
}

#pragma mark -- action
- (void)qidChoiceViewClicked:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onlineTestQidChoiceNavBarButtonClicked:)]) {
        [_delegate onlineTestQidChoiceNavBarButtonClicked:sender];
    }
}
#pragma mark --Gesture
- (void)nabBarTitleTapGestureDetected:(UITapGestureRecognizer *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(onlineTestQidChoiceNavBarTitleTapDetected:)]) {
        [_delegate onlineTestQidChoiceNavBarTitleTapDetected:sender];
    }
}


@end




//设置的常量
//cell高度
static CGFloat const CellHeight = 32;
//下部分collectionview高度
#define CollectionViewHeight SKXFrom6(250)
//cell标示
static NSString *CellIdentifier = @"QIDID";

@interface OnlineTestQidChoiceView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,OnlineTestQidChoiceNavBarViewDelegate>

@property (nonatomic, strong) UIView *bottomShowView;//底部需要显示的视图
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *superView;
/**
 导航视图
 */
@property (nonatomic, strong) OnlineTestQidChoiceNavBarView *qidChoiceNavBarView;

@end

@implementation OnlineTestQidChoiceView

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView  {
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
        _superView = superView;
        [self initCustomView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qidChoiceViewTapGestureDetected:)];
        // 利用代理方法解决后边手势与item点击事件之间的冲突
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
- (void)initCustomView {
    
    
    UIView *qidChoiceShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50 + CollectionViewHeight)];
    qidChoiceShowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:qidChoiceShowView];
    _bottomShowView = qidChoiceShowView;
    

    _qidChoiceNavBarView = [[OnlineTestQidChoiceNavBarView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    _qidChoiceNavBarView.delegate = self;
    [_bottomShowView addSubview:_qidChoiceNavBarView];
    
    [_bottomShowView  addSubview:self.collectionView];


}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        //CollectionView
        //创建流水布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //该方法也可以设置itemSize
        CGFloat itemWidth = (kScreen_Width - 50)/4;
        
        //处理之间的间隙问题
        //    CGFloat fixValue = 1 / [UIScreen mainScreen].scale;
        //    CGFloat realItemWidth = floor(itemWidth) + fixValue;
        //    if (realItemWidth < itemWidth) {
        //        realItemWidth += fixValue;
        //    }
        //    CGFloat realWidth = realItemWidth * 4 + 50;
        
        layout.itemSize =CGSizeMake(itemWidth, CellHeight);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        // 设置边缘的间距，默认是{0，0，0，0}
        layout.sectionInset = UIEdgeInsetsMake(15, 10, 10, 10);
        // UICollectionView默认的颜色就是黑色,所以建议设置背景颜色
        UICollectionView *collectionView = ({
            
            UICollectionView *collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            //设置UICollectionView的尺寸
            collectionView.frame = CGRectMake(0, 50 , kScreen_Width, CollectionViewHeight );
            collectionView.backgroundColor = [UIColor whiteColor];
            // 设置数据源,展示数据
            collectionView.dataSource = self;
            //设置代理,监听
            collectionView.delegate = self;
            [collectionView registerClass:[OnlineTestQidChoiceCell class] forCellWithReuseIdentifier:CellIdentifier];
            
            /* 设置UICollectionView的属性 */
            //设置滚动条
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.showsVerticalScrollIndicator = NO;
            collectionView.allowsMultipleSelection = YES;
            
            collectionView;
            
        });
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark -- collectiondatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OnlineTestDetailsVo *optionVo;
    if (self.totalArray.count > indexPath.row) {
        optionVo = self.totalArray[indexPath.row];
    }
    OnlineTestQidChoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (optionVo.isDone) {
        cell.isHighlighted = YES;
    } else {
        cell.isHighlighted = NO;
    }
    cell.qidLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogDebug(@"点击了%ld",(long)indexPath.row);
    self.selectedIndex = indexPath.row + 1;
    if (_delegate && [_delegate respondsToSelector:@selector(onlineTestQidChoiceViewQidSelectedIndex:)]) {
        [_delegate onlineTestQidChoiceViewQidSelectedIndex:indexPath.row];
    }
    [self sk_hide];
}


#pragma mark - OnlineTestQidChoiceNavBarViewDelegate

- (void)onlineTestQidChoiceNavBarTitleTapDetected:(UITapGestureRecognizer *)sender {
    
    
    [self sk_show];

}
- (void)onlineTestQidChoiceNavBarButtonClicked:(UIButton *)sender {
    
    if (sender.tag == 0) {
        if (self.selectedIndex > 2) {
            self.selectedIndex --;
            if (_hideTheNextButton) {
                self.hideTheNextButton = NO;
            }
        } else if (self.selectedIndex  == 2) {
           
            self.selectedIndex --;
            self.hideTheLastButton = YES;
        } else {
            self.hideTheLastButton = YES;
        }
    } else {
        if (self.selectedIndex < self.totalArray.count - 1) {
            self.selectedIndex ++;
            if (_hideTheLastButton) {
                self.hideTheLastButton = NO;
            }
        }else if (self.selectedIndex  == self.totalArray.count - 1) {
            
            self.selectedIndex ++;
            self.hideTheNextButton = YES;
        } else {
            self.hideTheNextButton = YES;

        }
    }
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(onlineTestQidChoiceViewNavBarItemClicked:topicIndex:)]) {
        [_delegate onlineTestQidChoiceViewNavBarItemClicked:sender topicIndex:self.selectedIndex - 1];
    }
}

#pragma mark - UIGestureRecognizerDelegate
// 手势代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
    if ([touch.view.superview isKindOfClass:[UICollectionViewCell class]]) {
        //如果点击的是UICollectionViewCell，touch.view是collectionViewCell的contentView，contentView的父view才是collectionCell
        return NO;
    }
    return YES;
    
}


#pragma mark -- UITapGestureRecognizer
- (void)qidChoiceViewTapGestureDetected:(UITapGestureRecognizer *)sender {
    
    [self sk_hide];
}

#pragma mark -- private
- (void)beginShowAllView {
    
    
    self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    _bottomShowView.frame = CGRectMake(0, kScreen_Height - CollectionViewHeight - 50, kScreen_Width, CollectionViewHeight + 50);
    self.hideTheNextButton = YES;
    self.hideTheLastButton = YES;

}
- (void)beginCloseCollectionView {
    
    self.frame = CGRectMake(0, kScreen_Height - 50, kScreen_Width, 50);
    _bottomShowView.frame = CGRectMake(0, 0, kScreen_Width, 50 + CollectionViewHeight);
    [self setNavBarState];
}


#pragma mark - setter
- (void)setHideTheLastButton:(BOOL)hideTheLastButton {
    _hideTheLastButton = hideTheLastButton;
    if (hideTheLastButton) {
        _qidChoiceNavBarView.leftButton.hidden = YES;
    } else {
        _qidChoiceNavBarView.leftButton.hidden = NO;
    }
    
}
- (void)setHideTheNextButton:(BOOL)hideTheNextButton {
    _hideTheNextButton = hideTheNextButton;
    if (hideTheNextButton) {
        _qidChoiceNavBarView.rightButton.hidden = YES;
    } else {
        _qidChoiceNavBarView.rightButton.hidden = NO;
    }
}
//默认的第一个选中

- (void)setTotalArray:(NSArray<OnlineTestDetailsVo *> *)totalArray {
    
    _totalArray = totalArray;
    [self.collectionView reloadData];

}
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    [self setNavBarState];
    
    NSString *combinationString = [NSString stringWithFormat:@"%ld/%ld",(long)_selectedIndex,(unsigned long)self.totalArray.count];
    NSString *selectedString = [NSString stringWithFormat:@"%ld",(long)_selectedIndex];
    if (!combinationString) return;
    
    NSMutableAttributedString *attribuTitle = [[NSMutableAttributedString alloc] initWithString:combinationString];
    [attribuTitle addAttributes:@{NSFontAttributeName:FONT_19,NSForegroundColorAttributeName:Color_system_red} range:NSMakeRange(0,selectedString.length)];
    [attribuTitle addAttributes:@{NSFontAttributeName:FONT_16,NSForegroundColorAttributeName:Color_6} range:NSMakeRange(selectedString.length,combinationString.length - selectedString.length)];
    
    _qidChoiceNavBarView.browseQidLabel.attributedText = attribuTitle;

}

- (void)setItemTitle:(NSString *)itemTitle {
    _itemTitle = itemTitle;
    

}
//设置导航条状态
- (void)setNavBarState {
    
    if (self.selectedIndex > 1) {
        self.hideTheLastButton = NO;
    } else{
        self.hideTheLastButton = YES;
    }
    if (self.selectedIndex < self.totalArray.count) {
        self.hideTheNextButton = NO;
        
    } else {
        self.hideTheNextButton = YES;
    }
}
#pragma mark - show hide methoms
- (void)sk_show {
    

    [self removeFromSuperview];
    [[[UIApplication  sharedApplication] keyWindow] addSubview:self] ;
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        weakSelf.alpha = 1;
        [weakSelf beginShowAllView];
        
    } completion:^(BOOL finished) {
        

    }];
}

- (void)sk_hide {
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [weakSelf beginCloseCollectionView];
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
        [_superView addSubview:weakSelf];
    }];
}


@end
