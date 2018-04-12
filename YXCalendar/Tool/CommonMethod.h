//
//  CommonMethod.h
//  Photographer
//
//  Created by AA on 15/8/1.
//  Copyright (c) 2015年 AA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol navgationButtonDelegate <NSObject>

- (void)btnClick:(UIButton *)btn;

@end

@interface CommonMethod : NSObject

@property(nonatomic, assign)id <navgationButtonDelegate>btnNavDelegate;
+ (CommonMethod *)getInstance;
@property (nonatomic, copy) NSString *accessToken;

//十六进制的颜色转换
+ (UIColor *)hexColor:(NSString *)color;


//判断手机号
+ (BOOL)checkTel:(NSString *)tel;

//时间戳转换
+ (NSString *)timeChange:(NSString *)time;

//判断是否允许中文输入
+(BOOL)isChinese:(NSString *)str;

//判断只允许中文，英文，数字
+(BOOL)isChineseAndNumber:(NSString *)str;


//是否允许输入表情
+(BOOL)isContainsEmoji:(NSString *)string;

//返回按钮
+ (void)backeTintcolor:(UIViewController *)viewcontroller;

//拨打客服电话
+ (void)callCustomerServicePhone:(NSString *)telNo view:(UIView *)view;


//判断邮箱号
+ (BOOL)validateEmail:(NSString *)email;


//HUD
+ (MBProgressHUD *)hud:(UIView *)viewHUD lableText:(NSString *)text;


//hud提示
+ (void)hudShow:(UIViewController *)viewController hudText:(NSString *)hudText;

+ (BOOL) isValidZipcode:(NSString*)value;//判断邮编

+ (void)setTextFieldLayer:(UITextField *)textField cornerRadius:(int)cornerRadius;

+ (void)setButtonLayer:(UIButton *)button cornerRadius:(int)cornerRadius;

+ (void)setViewLayer:(UIView *)view cornerRadius:(int)cornerRadius;

//手机号是否是数字
+ (BOOL)telPhoneIsNum:(UITextField *)textField;

+ (NSString *)getFilePath;

+(UIImage*)getImageFromURLwithUrl:(NSString*)imgURLStr;

+ (NSString *)getAddressPath;

+ (NSString *)getMailListPath;

//获取文字与字符混合的总字符数
+ (int)convertToInt:(NSString*)strtemp;

+(void)setLastCellSeperatorToLeft:(UITableViewCell *)cell;
/*
 友盟简化调用
 */

+ (void)UMPublicClick:(NSString *)url;

+(BOOL)isChinesed:(NSString *)str;


/*
 返回时间1990-01-01
 */

+ (NSDate *)dateWithNine;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


+ (void)addShadowToButton:(UIButton *)button
              withOpacity:(float)shadowOpacity
             shadowRadius:(CGFloat)shadowRadius
          andCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)color;
// 判断一个月有多少天
+ (NSInteger)monthDayCount:(NSInteger)month andYear:(NSInteger)year;
@end
