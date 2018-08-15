//
//  SKScrollView.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKScrollView.h"
#import "SKReScrollView.h"
@interface SKScrollView ()<UIScrollViewDelegate>

/**
 *  滚动视图 承载NewsListView
 */
@property (nonatomic , strong) SKReScrollView *listScrollView;

/**
 *  保存View对象的数组
 */
@property (nonatomic , strong) NSMutableArray *viewsArr;

/**
 滚动范围的竖直距离
 */
@property (nonatomic , assign) CGFloat contentSizeY;


@end

@implementation SKScrollView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpListScrollView];
        
        self.viewsArr = [NSMutableArray array];
    }
    
    return self;
}

- (void) setUpListScrollView{
    
    self.listScrollView = [[SKReScrollView alloc] initWithFrame:self.bounds];
    _contentSizeY = CGRectGetHeight(self.frame);
    // -- 整页翻动
    [self.listScrollView setPagingEnabled:YES];
    [self.listScrollView setDelegate:self];
    
    // -- 隐藏竖直方向滚动条
    [self.listScrollView setShowsVerticalScrollIndicator:NO];
    [self.listScrollView setShowsHorizontalScrollIndicator:NO];
    // -- 背景颜色
    [self.listScrollView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.listScrollView];
}

// -- 取到当前的View 并return
- (UIView *) getCurrentNewsListView{
    
    NSInteger currentIndex = self.listScrollView.contentOffset.x / kScreen_Width;
    // --
    SKListView *tmpView = nil;
    
    if (self.viewsArr.count > currentIndex) {
        
        tmpView = [self.viewsArr objectAtIndex:currentIndex];
    }
    else{
        
        NSLog(@"数组越界 %s in %@",__FUNCTION__,[self class]);
    }
    
    return tmpView;
}

// -- 添加MDSNNewListView的对象
- (void)loadNewsListView:(UIView *)view{
    
    // -- 重新设置Frame
    [view setFrame:CGRectMake(self.viewsArr.count * kScreen_Width, 0, kScreen_Width, _contentSizeY)];
    
    // -- 保存View到记录数组中
    [self.viewsArr addObject:view];
    
    // -- 滚动范围
    [self.listScrollView setContentSize:CGSizeMake(self.viewsArr.count * kScreen_Width, _contentSizeY)];
    
    [self.listScrollView addSubview:view];
}

#pragma -
#pragma mark - 根据分类频道选中按钮的下标进行操作 -
- (void) scrollToNewListViewWithIndex:(NSInteger)index{
    
    CGFloat contentOffSetX = (index - 1) * kScreen_Width;
    
    [self.listScrollView setContentOffset:CGPointMake(contentOffSetX, 0)];
    
    [self endScrollAndSendCurrentViewToResfresh];
}

#pragma -
#pragma mark - ScrollViewDelegate -
// -- 停止拖拽的时候调用 decelerate 减速
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // -- 停止减速（停止滚动了）
    if (decelerate == NO) {
        [self endScrollAndSendCurrentViewToResfresh];
    }
}

// -- 停止减速的时候调用
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self endScrollAndSendCurrentViewToResfresh];
}

// -- 停止滚动的时候把当前的View传出去，然后以便后续进行自动刷新
- (void) endScrollAndSendCurrentViewToResfresh{
    
    // -- 拿到当前视图的页数
    NSInteger pageIndex = self.listScrollView.contentOffset.x / kScreen_Width;
    UIView *tmpView = [self getCurrentNewsListView];
    if (self.getEndToView) self.getEndToView(tmpView);
    if (self.getEndscrollToIndex) {
        self.getEndscrollToIndex(pageIndex + 1);
    }
}




@end
