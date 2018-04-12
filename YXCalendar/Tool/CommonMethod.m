//
//  CommonMethod.m
//  Photographer
//
//  Created by AA on 15/8/1.
//  Copyright (c) 2015年 AA. All rights reserved.
//

#import "CommonMethod.h"

@implementation CommonMethod

//颜色
+ (UIColor *)hexColor:(NSString *)color{
    NSString *hexColor = color;
    
    if ([color characterAtIndex:0] == '#') {
        hexColor = [hexColor substringFromIndex:1];
    }
    
    NSString *rc = [hexColor substringWithRange:NSMakeRange(0, 2)];
    long r = strtol([rc UTF8String], NULL, 16);
    
    NSString *gc = [hexColor substringWithRange:NSMakeRange(2, 2)];
    long g = strtol([gc UTF8String], NULL, 16);
    
    NSString *bc = [hexColor substringWithRange:NSMakeRange(4, 2)];
    long b = strtol([bc UTF8String], NULL, 16);
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


//判断手机号
+ (BOOL)checkTel:(NSString *)tel{
    if (tel.length == 0) {//
        AlertViewShow( @"请输入手机号",@"确定",nil);
        
        return NO;
    }
    // @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"               ;
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    BOOL isMactch = [pred evaluateWithObject:tel];
    
    if (!isMactch) {
        AlertViewShow( @"请填写正确的手机号",@"确定",nil);
        
        return NO;
    }
    
    return isMactch;
}

+ (NSString *)timeChange:(NSString *)time{
    
    NSTimeInterval times=[time doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildates=[NSDate dateWithTimeIntervalSince1970:times];

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildates];

    return currentDateStr;//[currentDateStr substringToIndex:[currentDateStr rangeOfString:@"+"].location];
}


+(BOOL)isChinese:(NSString *)str
{
    /*
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL flag = [pred evaluateWithObject:str];
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [str isEqualToString:filtered];
    if (flag) {
        return YES;
    }
    if (canChange) {
        return YES;
    }
    return NO;
     */
    
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL flag = [pred evaluateWithObject:str];
    
    if(flag){
        return YES;
    }
    
    NSLog(@"flag=%d",flag);

    
    return NO;
}
+(BOOL)isChineseAndNumber:(NSString *)str
{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL flag = [pred evaluateWithObject:str];
    
    if(flag){
        return YES;
    }
    
    NSLog(@"flag=%d",flag);
    
    
    return NO;
}

+(BOOL)isChinesed:(NSString *)str
{
    for (int i = 0; i <str.length; i++) {
        NSString *mystring = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *emailRegexRegist = @"[\u4e00-\u9fa5]";// 匹配中文
        NSPredicate *emailTestRegist = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegexRegist];
        BOOL isChina =[emailTestRegist evaluateWithObject:mystring];
        if (!isChina) {
            return NO;
        }
    }
    return YES;
}

+(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

+ (void)backeTintcolor:(UIViewController *)viewcontroller{
    UIBarButtonItem *nItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    viewcontroller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    viewcontroller.navigationItem.backBarButtonItem=nItem;
}

+ (void)callCustomerServicePhone:(NSString *)telNo view:(UIView *)view{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telNo];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];}


+ (CommonMethod *)getInstance{
    static CommonMethod *comm = nil;
    
    @synchronized(self){
        if (!comm) {
            comm = [[self alloc] init];
        }
        return comm;
    }
}

+ (BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



+ (MBProgressHUD *)hud:(UIView *)viewHUD lableText:(NSString *)text{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:viewHUD];
    hud.alpha = 0.8;
    hud.label.text = text;
    hud.mode = MBProgressHUDModeIndeterminate;
    [viewHUD addSubview:hud];
    
    return hud;
}


+ (void)hudShow:(UIViewController *)viewController hudText:(NSString *)hudText{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
//    hud.labelText =hudText;
    hud.detailsLabel.text = hudText;
    hud.margin = 10.f;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3];
}


+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    long len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}

+ (void)setTextFieldLayer:(UITextField *)textField cornerRadius:(int)cornerRadius{

    textField.layer.cornerRadius = cornerRadius;  // 将图层的边框设置为圆角
    textField.layer.masksToBounds = YES; // 隐藏边界
//    textField.layer.borderWidth = 1;  // 给图层添加一个有色边框
//    textField.layer.borderColor = [CommonMethod hexColor:@"#E0E0E0"].CGColor;
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 20.0, 50.0)];//左端缩进15像素
//    textField.leftView = view;
//    view.backgroundColor = [UIColor redColor];
//    textField.leftViewMode =
//    UITextFieldViewModeAlways;
//    
//    textField.te
    
    
}

+ (void)setButtonLayer:(UIButton *)button cornerRadius:(int)cornerRadius{
    button.layer.cornerRadius = cornerRadius;  // 将图层的边框设置为圆角
    button.layer.masksToBounds = YES; // 隐藏边界
    button.layer.borderWidth = 1;  // 给图层添加一个有色边框
    button.layer.borderColor = [UIColor clearColor].CGColor;
}

+ (void)setViewLayer:(UIView *)view cornerRadius:(int)cornerRadius{
    view.layer.cornerRadius = cornerRadius;  // 将图层的边框设置为圆角
    view.layer.masksToBounds = YES; // 隐藏边界
    view.layer.borderWidth = 1;  // 给图层添加一个有色边框
    view.layer.borderColor = [CommonMethod hexColor:@"#E0E0E0"].CGColor;
}

+ (BOOL)telPhoneIsNum:(UITextField *)textField{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:telNum] invertedSet];
    
    NSString *filtered = [[textField.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL isTelNum = [textField.text isEqualToString:filtered];
    if (isTelNum == NO) {
        AlertViewShow(@"手机号输入不正确", @"提示", nil);
        
        return NO;
    }
    
    return YES;
}

+ (NSString *)getFilePath{
    //第一：读取documents路径的方法：
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ; //得到documents的路径，为当前应用程序独享
    
    NSString *documentD = [paths objectAtIndex:0];
    
    
    NSString *configFile = [documentD stringByAppendingPathComponent:@"/shop.plist"]; //得到documents目录下dujw.plist配置文件的路径
    
    return configFile;
    
}

+(UIImage*)getImageFromURLwithUrl:(NSString*)imgURLStr
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.yimaster.net/img/prd/%@",imgURLStr];
    NSMutableURLRequest *requestWithBodyParams = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *imageData = [NSURLConnection sendSynchronousRequest:requestWithBodyParams returningResponse:nil error:nil];
    UIImage *image = [UIImage imageWithData:imageData];
    //[_testImageView setImage:image];
    return image;
}

+ (NSString *)getAddressPath{
    //第一：读取documents路径的方法：
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ; //得到documents的路径，为当前应用程序独享
    
    NSString *documentD = [paths objectAtIndex:0];
    
    
    NSString *configFile = [documentD stringByAppendingPathComponent:@"/address.plist"]; //得到documents目录下dujw.plist配置文件的路径
    
    return configFile;
}

+ (NSString *)getMailListPath{
    //第一：读取documents路径的方法：
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ; //得到documents的路径，为当前应用程序独享
    
    NSString *documentD = [paths objectAtIndex:0];
    
    
    NSString *configFile = [documentD stringByAppendingPathComponent:@"/mailLists.plist"]; //得到documents目录下dujw.plist配置文件的路径
    
    return configFile;
}

//获取文字与字符混合的总字符数
+ (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    // 这里一定要使用gbk的编码方式，网上有很多用Unicode的，但是混合的时候都不行
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    char* p = (char*)[strtemp cStringUsingEncoding:gbkEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:gbkEncoding] ;i++) {
        if (p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
+(void)setLastCellSeperatorToLeft:(UITableViewCell *)cell
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

//+ (void)UMPublicClick:(NSString *)url{
//
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//
//    [UMSocialData defaultData].extConfig.qqData.url = url;
//
//
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
//
//
//    [UMSocialData defaultData].extConfig.qzoneData.url = url;
//
//
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//
//
//    [UMSocialData defaultData].extConfig.yxsessionData.url = url;
//
//
//    [UMSocialData defaultData].extConfig.yxtimelineData.url = url;
//
//
//}

+ (NSDate *)dateWithNine{
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];//格式化
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *da = [[NSDate alloc] init];
    da = [formatter dateFromString:@"1990-01-01"];
    return da;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 button周边加阴影，并且同时圆角
 */
+ (void)addShadowToButton:(UIButton *)button
              withOpacity:(float)shadowOpacity
             shadowRadius:(CGFloat)shadowRadius
          andCornerRadius:(CGFloat)cornerRadius shadowColor:(UIColor *)color
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = button.layer.frame;
    
    shadowLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(0, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    button.layer.shouldRasterize = YES;
    button.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [button.superview.layer insertSublayer:shadowLayer below:button.layer];
}

// 判断一个月有多少天
+(NSInteger)monthDayCount:(NSInteger)month andYear:(NSInteger)year
{
    NSInteger dayCount;
    switch (month) {
        case 1:
            dayCount = 31;
            break;
        case 2:
            if (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) {
                dayCount = 29;
            }else{
                dayCount = 28;
            }
            break;
        case 3:
            dayCount = 31;
            break;
        case 4:
            dayCount = 30;
            break;
        case 5:
            dayCount = 31;
            break;
        case 6:
            dayCount = 30;
            break;
        case 7:
            dayCount = 31;
            break;
        case 8:
            dayCount = 31;
            break;
        case 9:
            dayCount = 30;
            break;
        case 10:
            dayCount = 31;
            break;
        case 11:
            dayCount = 30;
            break;
        default:
            dayCount = 31;
            break;
    }
    return dayCount;
    
}

@end
