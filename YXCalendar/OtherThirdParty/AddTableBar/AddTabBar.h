//
//  AddTabBar.h
//  YXCalendar
//
//  Created by 易信 on 2018/4/9.
//  Copyright © 2018年 易信. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 自定义的TabBar
 */
@class AddTabBar;
@protocol AddTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(AddTabBar *)tabBar;
@end


@interface AddTabBar : UITabBar

@property(nonatomic,weak)id <AddTabBarDelegate> delegate;

@end
