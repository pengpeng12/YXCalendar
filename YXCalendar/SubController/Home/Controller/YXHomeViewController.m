//
//  YXHomeViewController.m
//  YXCalendar
//
//  Created by 易信 on 2018/4/9.
//  Copyright © 2018年 易信. All rights reserved.
//

#import "YXHomeViewController.h"
#import "RangePickerViewController.h"

@interface YXHomeViewController ()

@end

@implementation YXHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    
    RangePickerViewController *rangeCalendarVC = [[RangePickerViewController alloc]init];
    [self.view addSubview:rangeCalendarVC.view];
    [self addChildViewController:rangeCalendarVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
