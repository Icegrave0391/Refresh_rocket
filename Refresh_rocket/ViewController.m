//
//  ViewController.m
//  Refresh_rocket
//
//  Created by 张储祺 on 2018/4/25.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "ViewController.h"
#import "UIView+UIViewPlus.h"
@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) CAShapeLayer * shapeLayer ;
@property(nonatomic, strong) CAShapeLayer * rockerLayer ;
@property(nonatomic, strong) UIScrollView * scrollView ;

@end

@implementation ViewController
#pragma mark 惰性实例化
-(CAShapeLayer *)shapeLayer{
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer] ;
        _shapeLayer.fillColor = [UIColor colorWithRed:150/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor ;
    }
    return _shapeLayer ;
}

-(CAShapeLayer *)rockerLayer{
    if(!_rockerLayer){
        _rockerLayer = [CAShapeLayer layer] ;
    }
    return  _rockerLayer ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)] ;
    [scrollView setContentSize:CGSizeMake(self.view.width, self.view.height)] ;
    [scrollView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)] ;      //from top
    [scrollView setContentOffset:CGPointMake(0, 0)] ;
    scrollView.delegate = self ;
    self.scrollView = scrollView ;
    self.scrollView.showsVerticalScrollIndicator = YES ;
    self.scrollView.backgroundColor = [UIColor clearColor] ;
    [self.view addSubview:self.scrollView] ;
    
    [self.view.layer insertSublayer:self.shapeLayer atIndex:0 ];
    [self.shapeLayer addSublayer:self.rockerLayer] ;
    
    [self initRocket] ;
}

#pragma mark 实现方法
-(void)initRocket{
    self.rockerLayer.frame = CGRectMake(self.view.center.x - 32, -64 , 64, 64) ;
    self.rockerLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"2-Rocket"].CGImage) ;
    [self.shapeLayer addSublayer:self.rockerLayer] ;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scroll") ;
    CGFloat height = -scrollView.contentOffset.y ;    //scroll down => height < 0
    UIBezierPath * path = [UIBezierPath bezierPath] ;
    [path moveToPoint:CGPointMake(0, 0)] ;
    [path addLineToPoint:CGPointMake(self.view.width, 0)] ;
    
    if(height <= 100){
        [path addLineToPoint:CGPointMake(self.view.width, height)] ;
        [path addLineToPoint:CGPointMake(0, height)] ;
        CABasicAnimation * animation = [CABasicAnimation animation] ;
        animation.keyPath = @"position" ;
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, height - 32)] ;
        [self.rockerLayer addAnimation:animation forKey:nil] ;
        [self.rockerLayer setPosition:CGPointMake(self.view.center.x, height -32)] ;
        //add animation
        
    }else{
        //add animation
        [path addLineToPoint:CGPointMake(self.view.width, 100)] ;
        [path addQuadCurveToPoint:CGPointMake(0, 100) controlPoint:CGPointMake(self.view.center.x, height)] ;
        CABasicAnimation * animation = [CABasicAnimation animation] ;
        animation.keyPath = @"position" ;
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, height - 32)] ;
        [self.rockerLayer addAnimation:animation forKey:nil] ;
        [self.rockerLayer setPosition:CGPointMake(self.view.center.x, height -32)] ;
    }
    
    [path closePath] ;
    self.shapeLayer.path = path.CGPath ;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.y < -100){
        [scrollView setContentOffset:CGPointMake(0, -100) animated:YES] ;
    }else if(scrollView.contentOffset.y < 0){
        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES] ;
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -99 && scrollView.contentOffset.y > -101){
        
    };
}
@end
