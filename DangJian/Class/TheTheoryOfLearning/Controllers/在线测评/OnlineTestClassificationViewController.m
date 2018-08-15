//
//  OnlineTestClassificationViewController.m
//  DangJian
//
//  Created by Sakya on 17/5/22.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "OnlineTestClassificationViewController.h"
#import "PublickSingleTitleCell.h"
#import "OnlineTestListViewController.h"

@interface OnlineTestClassificationViewController ()
@property (nonatomic, strong) NSArray <NSDictionary *>*classArray;

@end

@implementation OnlineTestClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    [self initCustomView];
}
- (void)setUpNavigationBar {
    
    self.navigationItem.title = @"在线考试";
    
}
- (void)initCustomView {
    
}
- (NSArray <NSDictionary *>*)classArray {
    if (!_classArray) {
        
        _classArray = @[@{@"title":@"党史",
                            @"className":@"DS"},
                        @{@"title":@"党章党规",
                            @"className":@"DZ"},
                        @{@"title":@"系列讲话",
                            @"className":@"XLJH"},
                        @{@"title":@"理论推送",
                            @"className":@"LLTS"}];
    }
    return _classArray;
}
#pragma marl - tableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.classArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"TITLEID";
    NSDictionary *configParam;
    if (self.classArray.count > indexPath.row) {
        configParam = self.classArray[indexPath.row];
    }
    PublickSingleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[PublickSingleTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.title = [configParam objectForKey:@"title"];
    return cell;
    
}

#pragma marl - tableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellSingleTextHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OnlineTestListViewController *onlineTestListView = [[OnlineTestListViewController alloc] init];
    NSDictionary *configParam;
    if (self.classArray.count > indexPath.row) {
        configParam = self.classArray[indexPath.row];
    }
    onlineTestListView.configParams = configParam;
    [self.navigationController pushViewController:onlineTestListView animated:YES];
    
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
