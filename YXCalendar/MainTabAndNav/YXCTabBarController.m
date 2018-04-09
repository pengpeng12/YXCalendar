//
//  YXCTabBarController.m
//  YXCalendar
//
//  Created by 易信 on 2018/4/9.
//  Copyright © 2018年 易信. All rights reserved.
//

#import "YXCTabBarController.h"
#import "YXCNavigationController.h"
#import "YXHomeViewController.h"
#import "YXFindViewController.h"
#import "YXMyViewController.h"
#import "NewTaskViewController.h"
#import "AddTabBar.h"

@interface YXCTabBarController ()<AddTabBarDelegate>
@property (nonatomic,weak)UIButton *plus;
//弹出的view
@property (nonatomic, weak)UIView *blurView;
@end

@implementation YXCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YXHomeViewController *home = [[YXHomeViewController alloc]init];
    [self addChildViewController:home title:@"首页" image:@"tabbar_home" selImage:@"tabbar_home_selected"];
    
    
    YXMyViewController *profile = [[YXMyViewController alloc] init];
    [self addChildViewController:profile title:@"我" image:@"tabbar_profile" selImage:@"tabbar_profile_selected"];
    
    //更换系统自带的tabbar
    AddTabBar *tab = [[AddTabBar alloc]init];
    tab.delegate = self;
    [self setValue:tab forKey:@"tabBar"];
    
    //调整UItabbarBtn的大小
//    CGFloat tabbarBtnW = kScreen_Width *0.25;
//    NSInteger index = 0;
//    for (int i = 0;i < self.tabBar.subviews.count;i++){
//        //拿到每一个子控件
//        UIView *view = self.tabBar.subviews[i];
//        //判断是否是UITabBarButton这个子控件
//        if([view isKindOfClass:NSClassFromString(@"UITabBarButton")]){
//            view.width = tabbarBtnW;
//            view.left = index*tabbarBtnW;
//            index ++;
//            if(index == 2){
//                index++;
//            }
//        }
//    }
}

#pragma mark - 添加子控制器
-(void)addChildViewController:(UIViewController *)childVc  title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage {
    static NSInteger index = 0;
    //设置子控制器的TabBarButton属性
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.tag = index;
    index++;
    //让子控制器包装一个导航控制器
    YXCNavigationController *nav = [[YXCNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

+ (void)initialize
{
    //设置未选中的TabBarItem的字体颜色、大小
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    //设置选中了的TabBarItem的字体颜色、大小
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] =  [UIColor orangeColor];
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"点击的item:%ld title:%@", item.tag, item.title);
}

#pragma mark - 加号按钮响应方法
-(void)tabBarDidClickPlusButton:(AddTabBar *)tabBar {
    NSLog(@"点击加号???");
    UIView *blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    blurView.backgroundColor = [UIColor redColor];
    self.blurView = blurView;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tapAction:)];
    tap.numberOfTapsRequired =1;
    tap.numberOfTouchesRequired =1;
    [blurView addGestureRecognizer:tap];
    [self.view addSubview:blurView];
    
    UIView *bottom = [[UIView alloc]init];
    bottom.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.height, 44);
    bottom.backgroundColor = [UIColor whiteColor];
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.frame = CGRectMake((self.view.bounds.size.width - 25) * 0.5, 8, 25, 25);
    [plus setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateNormal];
    [bottom addSubview:plus];
    
    [UIView animateWithDuration:0.2 animations:^{
        plus.transform = CGAffineTransformMakeRotation(M_PI_4);
        self.plus = plus;
    }];
    [plus addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [blurView addSubview:bottom];
    
}


#pragma mark - 消失
-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self closeClick];
}

#pragma mark - 关闭按钮
-(void)closeClick {
    NSLog(@"点击了关闭按钮");
    [self.blurView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
