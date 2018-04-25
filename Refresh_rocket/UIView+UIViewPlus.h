//
//  UIView+UIViewPlus.h
//  Refresh_rocket
//
//  Created by 张储祺 on 2018/4/25.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <UIKit/UIKit.h>
//函数
CGPoint CGRectGetCenter(CGRect rect) ;                //获取中心点
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center) ;              //移动至中心点



@interface UIView (UIViewPlus)
@property(nonatomic, assign) CGPoint origin ;
@property(nonatomic, assign) CGSize size ;

@property(nonatomic, readonly) CGPoint bottomLeft ;
@property(nonatomic, readonly) CGPoint bottomRight ;
@property(nonatomic, readonly) CGPoint topRight ;

@property(nonatomic, assign) CGFloat height ;
@property(nonatomic, assign) CGFloat width ;

@property(nonatomic, assign) CGFloat top ;
@property(nonatomic, assign) CGFloat left ;
@property(nonatomic, assign) CGFloat bottom ;
@property(nonatomic, assign) CGFloat right ;

-(void)moveBy: (CGPoint)delta ;
-(void)scaleBy: (CGFloat) scaleFactor ;
-(void)fitInSize :(CGSize) size ;

-(UIImage *)convertViewToImage ;

@end
