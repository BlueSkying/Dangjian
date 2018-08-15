//
//  MYCalendarView.m
//  Sedafojiao
//
//  Created by T_yun on 16/5/25.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "MYCalendarView.h"
#import "MYCalendarCollectionCell.h"
#import "SKPlaceholderView.h"
#import "UIImage+CornerRadius.h"
#import "MYCalendarDayModel.h"
#import "dayWorkCell.h"
#define UPVIEW_HEIGHT 44
#define MIDDEL_HEIGHT 30
#define HEADER_HEIGHT 20
#define HOLIDAY_HTIGHT 50


@interface MYCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;

/**显示日历*/
@property (nonatomic, strong) UICollectionView *collectionView;

/**显示事项*/
@property (nonatomic, strong) UITableView *tableView;

/**第一个模型  用于判断日历从哪儿开始*/
@property (nonatomic, strong) MYCalendarDayModel *firstModel;

/**上一次选中的cell*/
@property (nonatomic, weak) MYCalendarCollectionCell *lastCell;

/**最后一条灰线*/
@property (nonatomic, strong) UIView *lastLine;

/**白色背景*/
@property (nonatomic, strong) UIView *bgView;

/**tableview数据源*/
@property (nonatomic, copy) NSArray *tableDataArr;

/**tableview占位图*/
@property (nonatomic, strong) SKPlaceholderView *placeholderView;

@end

@implementation MYCalendarView
//static CGFloat const CellMargin = 1.0f;
static NSUInteger const DaysPerWeek = 7;
static NSString *reuserID = @"CollectionCell";
static CGFloat const CellHight = 55.0f;

- (SKPlaceholderView *)placeholderView {
    if(!_placeholderView) {
        
        _placeholderView = [[SKPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, CGRectGetHeight(self.tableView.frame)) placeholderType:SKPlaceholderViewSimpleType];
        _placeholderView.imageName = @"defaultPlaceholder_noContent_icon";
        _placeholderView.titleText = @"暂无内容";
        _placeholderView.titleLabel.textColor = Color_9;
        
        [self.tableView addSubview:_placeholderView];
    }
    
    return _placeholderView;
}

- (NSArray *)tableDataArr
{
    if (!_tableDataArr) {
        _tableDataArr = @[];
    }
    return _tableDataArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = SystemGrayBackgroundColor;
        [self customSubviews];
        //接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedTodayCell:) name:@"MYTodayCell" object:nil];

    }
    return self;
}


//处理左右月份切换 留api外面调用
- (void)dealWithYearButton:(BOOL)isLeft {

    NSString *month = @"";
    NSString *year = self.year;
    if (isLeft == YES) {
        
        month = [NSString stringWithFormat:@"%02d", [self.month intValue] - 1];
    } else {
        
        month = [NSString stringWithFormat:@"%02d", [self.month intValue] + 1];
    }
    if ([month isEqualToString:@"00"]) {
        
        month = @"12";
        year = [NSString stringWithFormat:@"%d", [year intValue] - 1];
    }
    if ([month isEqualToString:@"13"]) {
        
        month = @"01";
        year = [NSString stringWithFormat:@"%d", [year intValue] + 1];
    }
    
    
    [self getCalendarWithYear:year month:month];
}


- (void)customSubviews {
    
    //增加左右滑动的手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToLeft)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToRight)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
    
    self.yearMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, kScreen_Width, 25)];
    self.yearMonthLabel.text = @"";
    self.yearMonthLabel.textColor = Color_system_red;
    self.yearMonthLabel.textAlignment = NSTextAlignmentCenter;
    self.yearMonthLabel.font = [UIFont systemFontOfSize:21];
    
    [self addSubview:self.yearMonthLabel];
    
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(SKXFrom6(30) , 80, 20, 25)];
    [left setImage:[UIImage imageNamed:@"leftImage"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(clickToLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:left];
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-SKXFrom6(30)-20, 80, 20, 25)];
    [right setImage:[UIImage imageNamed:@"rightImage"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(clickToRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:right];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.yearMonthLabel.frame) + 10, kScreen_Width, 30 )];
    header.backgroundColor = SystemGrayBackgroundColor;
    [self addSubview:header];
    
    UIView *SepView = [[UIView alloc] initWithFrame:CGRectMake(0, 28, kScreen_Width, 2)];
    UIColor *shadowColor = [Color_systemNav_red_top colorWithAlphaComponent:0.1];

    [SepView setBackgroundColor:shadowColor];
    [header addSubview:SepView];
    
    //头视图里面的label
    NSArray *titles = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    CGFloat lbWidth = kScreen_Width / DaysPerWeek;
    for (int i = 0; i < titles.count; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * lbWidth, -5, lbWidth, CGRectGetHeight(header.frame))];
        label.font = [UIFont systemFontOfSize:14];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HexRGB(0x666666);

        [header addSubview:label];
    }
    
    //下方的日历collection
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect collectionRect = CGRectMake(0, CGRectGetMaxY(header.frame), kScreen_Width, CellHight * 5);
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout];
    self.collectionView = collection;
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate = self;
    collection.dataSource = self;
    //注册
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([MYCalendarCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuserID];
    
    CGFloat itemWidth = floorf((kScreen_Width) / 7);
    
    layout.itemSize = CGSizeMake(itemWidth, CellHight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    //每行cell的分割线
    for (int i = 0; i <= 3; i++) {
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CellHight * (i+1), kScreen_Width, 1)];
        line.backgroundColor = THEME_BACKCOLOR;
        
        [collection addSubview:line];
    }
    
    //最后一根线条
    self.lastLine = [[UIView alloc] initWithFrame:CGRectMake(0, CellHight * 5, kScreen_Width, 1)];
    self.lastLine.backgroundColor = THEME_BACKCOLOR;
    
    
    [self addSubview:collection];
    
    UIView *VerticalLine = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.collectionView.frame)+10, 3, 15)];
    VerticalLine.backgroundColor = [UIColor redColor];
    
    [self addSubview:VerticalLine];
    
    UILabel *todayThing = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(VerticalLine.frame)+10, CGRectGetMaxY(self.collectionView.frame), 150, 35)];
    todayThing.text = @"今日事项";
    todayThing.textAlignment = NSTextAlignmentLeft;
    todayThing.font = [UIFont systemFontOfSize:17];
    todayThing.textColor = HexRGB(0x333333);
    
    [self addSubview:todayThing];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+35, kScreen_Width, kScreen_Height-CGRectGetMaxY(self.collectionView.frame)-30)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    [self addSubview:self.tableView];
    
}


#pragma mark <UICollectionView>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count + self.firstModel.weekday;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MYCalendarDayModel *firstModel = self.firstModel;
    if (firstModel == nil)  return nil;
    
    MYCalendarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserID forIndexPath:indexPath];
    //第一天是周几 前面的没有model
    NSInteger firstWeekday = firstModel.weekday;
    if (indexPath.row >= firstWeekday) {
        
        cell.model = self.dataArray[indexPath.row - firstWeekday];
    } else {
    
        cell.model = nil;
    }
    
    return cell;
}

//返回cell的宽和高
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger numberOfMaigin = 9;
    CGFloat with = floorf((collectionView.frame.size.width) / DaysPerWeek);
    CGFloat height = CellHight;
    
    return CGSizeMake(with, height);
}

//每行cell之间的间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0.01f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    MYCalendarCollectionCell *cell = (MYCalendarCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.model.dayWorkArr.count>0) {
        [self.placeholderView setHidden:YES];
    }else {
        [self.placeholderView setHidden:NO];
    }
    if ([cell isEqual:self.lastCell]) {
        
        return;
    } else {
    
        cell.isMySelcted = YES;
    }
    self.lastCell.isMySelcted = NO;
    
    self.lastCell = cell;
    
}

#pragma mark <UItableView>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"dayWorkID";
    dayWorkCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];;
    if (!cell) {
        cell = [[dayWorkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    dayWorkModel *model = self.tableDataArr[indexPath.row];
    cell.titleLabel.text = model.subject;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !self.pushBlock ? :self.pushBlock(self.tableDataArr[indexPath.row]);
}

#pragma mark 数据源
/**数据源*/
- (void)setDataArray:(NSMutableArray *)dataArray {

    _dataArray = dataArray;
    
    //取消上一次选择
    self.lastCell.isMySelcted = NO;
    
    self.firstModel = [dataArray firstObject];
    
    [self.collectionView reloadData];
}

/**藏历一些信息*/
- (void)setFirstModel:(MYCalendarDayModel *)firstModel {

    _firstModel = firstModel;
    
      //计算最后一条线是否加上
    if (firstModel.weekday + self.dataArray.count > 35) {
        
        [self.collectionView addSubview:self.lastLine];
    } else {
    
        [self.lastLine removeFromSuperview];
    }
}

/**上次选中的cell*/
- (void)setLastCell:(MYCalendarCollectionCell *)lastCell {

    _lastCell = lastCell;
    
    MYCalendarDayModel *model = lastCell.model;

    self.tableDataArr = model.dayWorkArr.copy;
    
    [self.tableView reloadData];
}


#pragma mark 数据

- (void)getData {
    
    //初始进入为 当前年月
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
    
    self.year = [NSString stringWithFormat:@"%ld", (long)[dateComponent year]];
    self.month = [NSString stringWithFormat:@"%02ld", (long)[dateComponent month]];
    
    [self getCalendarWithYear:self.year month:self.month];
}

- (void)getCalendarWithYear:(NSString *)year month:(NSString *)month {
    
    
      [InterfaceManager getOrganizationLsitWithjMonth:[NSString stringWithFormat:@"%@-%@", year, month] success:^(id result) {
          
          if ([ThePartyHelper showPrompt:YES returnCode:result]) {

              self.year = year;
              self.month = month;
              self.yearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月", year,month];
              NSMutableArray *arr = [NSMutableArray array];
              
              NSInteger number = [TyunTool getNumberWithMonth:[NSString stringWithFormat:@"%@/%@", self.year, self.month]];
              
              //事项数组
              NSArray *workDayarr = [dayWorkModel mj_objectArrayWithKeyValuesArray:result[@"data"]];

              //生成这个月日历天数的数组，自己生成
              for (int i =1; i<=number; i++) {
                  
                  NSString *day = [NSString stringWithFormat:@"%02d", i];
                  MYCalendarDayModel *model = [[MYCalendarDayModel alloc] init];
                  model.gong_li = [NSString stringWithFormat:@"%@/%@/%@", self.year, self.month,day];
                  model.day = [TyunTool LunarForSolar:model.gong_li];
                  //遍历有事项的数组如果当天有事项就把事项赋值
                  [workDayarr enumerateObjectsUsingBlock:^(dayWorkModel *dayModel, NSUInteger idx, BOOL * _Nonnull stop) {
                      
                      if ([model.gong_li isEqualToString:dayModel.workDayDate]){
                       //把当天的事项全都加在一个数组里面
                          model.workDayDate = dayModel.workDayDate;
                          dayWorkModel *dayModels = [[dayWorkModel alloc] init];
                          dayModels.content = dayModel.content;
                          dayModels.subject = dayModel.subject;
                          
                          [model.dayWorkArr addObject:dayModels];
                          
                      }
                  }];
                  [arr addObject:model];
              }
              
              self.dataArray = arr;
          }
      } failed:^(id error) {
        
      }];
}


#pragma mark 通知
- (void)recievedTodayCell:(NSNotification *)notif {

    MYCalendarCollectionCell *cell = (MYCalendarCollectionCell *)notif.object;
    if (cell.model.dayWorkArr.count>0) {
        [self.placeholderView setHidden:YES];
    }else {
        [self.placeholderView setHidden:NO];
    }
    cell.isMySelcted = YES;
    self.lastCell = cell;
    
}

#pragma mark 左右滑动手势
- (void)swipeToLeft {

    [self dealWithYearButton:NO];
}

- (void)swipeToRight {

    [self dealWithYearButton:YES];
}

#pragma mark 左右点击
- (void)clickToLeft {
    
    [self dealWithYearButton:YES];
}

- (void)clickToRight {
    
    [self dealWithYearButton:NO];
}

@end
