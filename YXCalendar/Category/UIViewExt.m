/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIViewExt.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint) origin
{
	return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
	return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
	return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

- (CGFloat) top
{
	return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

- (CGFloat) left
{
	return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

- (CGFloat) bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

- (CGFloat) right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
	CGPoint newcenter = self.center;
	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
	CGRect newframe = self.frame;
	newframe.size.width *= scaleFactor;
	newframe.size.height *= scaleFactor;
	self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;	
}

-(CGFloat)dc_centerX{
    
    return self.center.x;
}

-(void)setDc_centerX:(CGFloat)dc_centerX{
    
    CGPoint dcFrmae = self.center;
    dcFrmae.x = dc_centerX;
    self.center = dcFrmae;
}

-(CGFloat)dc_centerY{
    
    return self.center.y;
}

-(void)setDc_centerY:(CGFloat)dc_centerY{
    
    CGPoint dcFrame = self.center;
    dcFrame.y = dc_centerY;
    self.center = dcFrame;
}

+(instancetype)dc_viewFromXib
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

/**
 tableviewIOS11适配，明杰刷新跳动和组头组脚有空白
 
 @param tableView 滚动视图
 @param ishaveTabbar 底部是否有工具条，有工具条传入YES，没有传入NO
 */
+(void)tablevieiOS11:(UITableView*)tableView isHaveTabbar:(BOOL)ishaveTabbar{
#pragma mark =====继承：XMRootViewController用【系统导航栏的】的 iOS11 tableview偏移适配（放到tableview初始化里面）S==============
    if (@available(iOS 11.0, *)) {
        //1、tableView的section之间间距变大问题,解决办法：初始化的时候增加以下代码
        //tableView 头部视图和尾部视图出现一块留白问题
        //iOS11下tableview默认开启了self-Sizing，Headers, footers, and cells都默认开启Self-Sizing，所有estimated 高度默认值从iOS11之前的 0 改变为
        tableView.estimatedRowHeight =0;
        tableView.estimatedSectionHeaderHeight =0;
        tableView.estimatedSectionFooterHeight =0;
        //2、MJ刷新异常，上拉加载出现跳动刷新问题,解决办法：初始化的时候增加以下代码（tableView和collectionView类似）
        tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        if (ishaveTabbar==YES) {
            //底部有工具条
            tableView.contentInset =UIEdgeInsetsMake(0,0, 0, 0);//底部有tabbar或者工具条的不改变偏移
        }else{
            //底部无工具条
            tableView.contentInset =UIEdgeInsetsMake(0,0, MC_TabbarSafeBottomMargin, 0);//距离底部的距离，防止拉到最后被盖住
        }
        tableView.scrollIndicatorInsets =tableView.contentInset;
    }
#pragma mark ======== iOS11 tableview偏移适配 E==============
}


/**
 collectionViewIOS11适配，明杰刷新跳动和组头组脚有空白
 
 @param collectionView 滚动视图
 @param ishaveTabbar 底部是否有工具条，有工具条传入YES，没有传入NO
 */
+(void)collectionViewiOS11:(UICollectionView *)collectionView isHaveTabbar:(BOOL)ishaveTabbar{
#pragma mark =====继承：XMRootViewController用【系统导航栏的】的 iOS11 tableview偏移适配（放到tableview初始化里面）S==============
    if (@available(iOS 11.0, *)) {
        //2、MJ刷新异常，上拉加载出现跳动刷新问题,解决办法：初始化的时候增加以下代码（tableView和collectionView类似）
        collectionView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        if (ishaveTabbar==YES) {
            //底部有工具条
            collectionView.contentInset =UIEdgeInsetsMake(0,0, 0, 0);//底部有tabbar或者工具条的不改变偏移
        }else{
            //底部无工具条
            collectionView.contentInset =UIEdgeInsetsMake(0,0, MC_TabbarSafeBottomMargin, 0);//距离底部的距离，防止拉到最后被盖住
        }
        collectionView.scrollIndicatorInsets =collectionView.contentInset;
    }
#pragma mark ======== iOS11 tableview偏移适配 E==============
}

@end
