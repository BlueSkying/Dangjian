//
//  MainNavigationController.m
//  ThePartyBuild
//
//  Created by Sakya on 17/4/24.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 关键行
    self.interactivePopGestureRecognizer.delegate = self;
    
    self.delegate=self;

}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        //获取上一导航视图的文字
        NSString *viewTitle = [self.viewControllers lastObject].title;
        if (viewTitle == nil) {
            viewTitle = [self.viewControllers lastObject].navigationItem.title;
        }
        UIBarButtonItem *popToPreButton = [self barButtonItemWithImage:@"navBar_whiteBack_icon" highImage:nil backTitle:viewTitle target:self action:@selector(popToPre)];
        viewController.navigationItem.leftBarButtonItem =  popToPreButton;
    }
    [super pushViewController:viewController animated:animated];
}
//这里可以封装成一个分类
- (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName highImage:(NSString *)highImageName backTitle:(NSString *)backTitle target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    button.bounds = CGRectMake(0, 0, 50, 44);
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, - 5);
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    button.imageView.contentMode = UIViewContentModeLeft;
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)popToPre
{
    [self popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    // 当前页面是显示结果页，不响应滑动手势
    UIViewController *vc = [self.childViewControllers lastObject];
    if ([vc isKindOfClass:[MainNavigationController class]]) {
        return NO;
    }
//    for (UIViewController *tmpViewController in self.childViewControllers) {
//        if (tmpViewController && [tmpViewController isKindOfClass:[UIViewController class]]) {
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark --------navigation delegate
//该方法可以解决popRootViewController时tabbar的bug
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //删除系统自带的tabBarButton
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }
    
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
