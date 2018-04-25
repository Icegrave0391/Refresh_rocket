//
//  UIView+UIViewPlus.m
//  Refresh_rocket
//
//  Created by 张储祺 on 2018/4/25.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "UIView+UIViewPlus.h"
CGPoint CGRectGetCenter(CGRect rect) {
    CGPoint point ;
    point.x = CGRectGetMidX(rect) ;
    point.y = CGRectGetMidY(rect) ;
    return point ;
}
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center){
    CGRect newRect = CGRectZero ;
    newRect.origin.x = center.x - CGRectGetMidX(rect) ;
    newRect.origin.y = center.y - CGRectGetMidY(rect) ;
    newRect.size = rect.size ;
    
    return newRect ;
}

@implementation UIView (UIViewPlus)

//原点的setter和getter
-(CGPoint)origin{
    return self.frame.origin ;
}
-(void)setOrigin:(CGPoint)origin{
    CGRect newFrame = self.frame ;
    newFrame.origin = origin ;
    self.frame = newFrame ;
}
//size的setter和getter
-(CGSize)size{
    return self.frame.size ;
}

-(void)setSize:(CGSize)size{
    CGRect newFrame = self.frame ;
    newFrame.size = size ;
    self.frame = newFrame ;
}
//view location
-(CGPoint)bottomLeft{
    CGFloat x = self.frame.origin.x ;
    CGFloat y = self.frame.size.height + self.frame.origin.x ;
    return CGPointMake(x, y) ;
}

-(CGPoint)bottomRight{
    CGFloat x = self.frame.origin.x + self.frame.size.width ;
    CGFloat y = self.frame.origin.y + self.frame.size.height ;
    return CGPointMake(x, y) ;
}

-(CGPoint)topRight{
    CGFloat x = self.frame.origin.x + self.frame.size.width ;
    CGFloat y = self.frame.origin.y ;
    return CGPointMake(x, y) ;
}

-(CGFloat)height{
    return self.frame.size.height ;
}
-(void)setHeight:(CGFloat)height{
    CGRect frame = self.frame ;
    frame.size.height = height ;
    self.frame = frame ;
}

-(CGFloat)width{
    return self.frame.size.width ;
}
-(void)setWidth:(CGFloat)width{
    CGRect frame = self.frame ;
    frame.size.width = width ;
    self.frame = frame ;
}

-(CGFloat)top{
    return self.frame.origin.y ;
}
-(void)setTop:(CGFloat)top{
    CGRect frame = self.frame ;
    frame.origin.y = top ;
    self.frame = frame ;
}

-(CGFloat)left{
    return self.frame.origin.x ;
}
-(void)setLeft:(CGFloat)left{
    CGRect frame = self.frame ;
    frame.origin.x = left ;
    self.frame = frame ;
}

-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height ;
}
-(void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame ;
    frame.origin.y = bottom - self.frame.size.height ;
    self.frame = frame ;
}

-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width ;
}
-(void)setRight:(CGFloat)right{
    CGRect frame = self.frame ;
    frame.origin.x = right - self.frame.size.width ;
    self.frame = frame ;
}

//move
-(void)moveBy:(CGPoint)delta{
    CGPoint center = self.center ;
    center.x += delta.x ;
    center.y += delta.y ;
    
    self.center = center ;
}
//scale
-(void)scaleBy:(CGFloat)scaleFactor{
    CGRect frame = self.frame ;
    frame.size.width *= scaleFactor ;
    frame.size.height *= scaleFactor ;
    self.frame = frame ;
}
//fit
-(void)fitInSize:(CGSize)size{
    CGRect frame = self.frame ;
    CGFloat scale ;
    if(frame.size.height > size.height){
        scale = size.height/frame.size.height ;
        frame.size.height *= scale ;
    }
    if(frame.size.width > size.width){
        scale = size.width/frame.size.width ;
        frame.size.width *= scale ;
    }
    self.frame = frame ;
}
//截屏
-(UIImage *)convertViewToImage{
    CGSize size = self.bounds.size ;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale) ;
    [self.layer renderInContext:UIGraphicsGetCurrentContext()] ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext() ;
    
    UIGraphicsEndImageContext() ;
    return image ;
}

@end
