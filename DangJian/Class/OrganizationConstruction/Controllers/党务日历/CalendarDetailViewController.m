//
//  CalendarDetailViewController.m
//  ThePartyBuild
//
//  Created by TuringLi on 17/5/12.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "CalendarDetailViewController.h"

@interface CalendarDetailViewController ()

@property (nonatomic, strong) UIScrollView *BG;
@end

@implementation CalendarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self initCustomView];
    // Do any additional setup after loading the view.
}

- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"详情";
}

- (void)initCustomView {
    
    _BG = [[UIScrollView alloc] init];
    _BG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_BG];

    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(SKXFrom6(15), 10, kScreen_Width-30, 44)];
    [_BG addSubview:self.textLabel];
    self.textLabel.text = self.model.content;
    self.textLabel.textColor = Color_3;
    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.textLabel.numberOfLines = 0;
    [self.textLabel sizeToFit];
    CGFloat textLabelHeight = CGRectGetHeight(self.textLabel.frame);
    [_BG setContentSize:CGSizeMake(0, textLabelHeight + 20)];
    textLabelHeight = (textLabelHeight > kScreen_Height - 64 - 20) ? 0  : kScreen_Height - textLabelHeight - 64 - 30;
    [_BG mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        make.top.offset(64 + 10);
        make.right.offset(0);
        make.bottom.offset(-textLabelHeight);
    }];
    
    
    
}

- (void)setModel:(dayWorkModel *)model {
    
    _model = model;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
