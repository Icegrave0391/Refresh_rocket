//
//  ViewController.m
//  Refresh_rocket
//
//  Created by 张储祺 on 2018/4/25.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import "ViewController.h"
#import "UIView+UIViewPlus.h"
#import "CARocketLayer.h"
@interface ViewController ()<UIScrollViewDelegate, CAAnimationDelegate>

@property(nonatomic, strong) CAShapeLayer * shapeLayer ;
@property(nonatomic, strong) CARocketLayer * rockerLayer ;
@property(nonatomic, strong) UIScrollView * scrollView ;
@property(nonatomic, strong) CAShapeLayer * circleLayer ;    //手势触控位置圆圈
@property(nonatomic, strong) NSTimer * timer ;    //计时 用于判断手势状态改变 触发火箭抖动
@property(nonatomic, strong) NSMutableArray * circleArr ;

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

-(CARocketLayer *)rockerLayer{
    if(!_rockerLayer){
        _rockerLayer = [CARocketLayer layer] ;
        _rockerLayer.frame = CGRectMake(self.view.center.x - 32, -64 , 64, 64) ;
        _rockerLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"2-Rocket"].CGImage) ;
        _rockerLayer.dragDown = YES ;
        [self.shapeLayer addSublayer:_rockerLayer] ;
    }
    return _rockerLayer ;
}
-(CAShapeLayer *)circleLayer{
    if(!_circleLayer){
        _circleLayer = [CAShapeLayer layer] ;
        self.circleLayer.fillColor = [UIColor colorWithRed:100.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1].CGColor ;
        _circleLayer.frame = self.view.bounds ;
        [self.scrollView.layer addSublayer:_circleLayer] ;
    }
    return _circleLayer ;
}
-(NSMutableArray *)circleArr{
    if(!_circleArr){
        _circleArr = [NSMutableArray array] ;
    }
    return _circleArr ;
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
    
}

#pragma mark 实现方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //初始化手势圆点
        if(self.scrollView.tracking == YES ){
            CGPoint currentCenterPoint = [self.scrollView.panGestureRecognizer locationInView:self.scrollView] ;
            
            UIBezierPath * path = [UIBezierPath bezierPath] ;
            [path moveToPoint:CGPointMake(currentCenterPoint.x, currentCenterPoint.y - 20)] ;
            [path addArcWithCenter:currentCenterPoint radius:15.0 startAngle:- M_PI_2 endAngle:M_PI * 1.5 clockwise:YES] ;
            self.circleLayer.path = path.CGPath ;
        }
        //处理火箭抖动
        if(!self.timer && self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged){
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(stateDetection) userInfo:nil repeats:YES] ;
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes] ;
        }
    
        //展示shapeLayer以及火箭rocketlayer
        CGFloat height = -scrollView.contentOffset.y ;    //scroll down => height < 0
        UIBezierPath * path = [UIBezierPath bezierPath] ;
        [path moveToPoint:CGPointMake(0, 0)] ;
        [path addLineToPoint:CGPointMake(self.view.width, 0)] ;
        
        if(height <= 100){
            [path addLineToPoint:CGPointMake(self.view.width, height)] ;
            [path addLineToPoint:CGPointMake(0, height)] ;
            //火箭是在下拉状态
            if(self.rockerLayer.dragDown == YES){
                CABasicAnimation * animation = [CABasicAnimation animation] ;
                //火箭位置
                animation.keyPath = @"position" ;
                animation.duration = 0.1f ;
                animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, height - 32)] ;
                [self.rockerLayer addAnimation:animation forKey:nil] ;
                [self.rockerLayer setPosition:CGPointMake(self.view.center.x, height -32)] ;
            }
            
        }else{
            //add animation
            [path addLineToPoint:CGPointMake(self.view.width, 100)] ;
            [path addQuadCurveToPoint:CGPointMake(0, 100) controlPoint:CGPointMake(self.view.center.x, height)] ;
            
            CGPoint P0 = CGPointMake(self.view.width, 100) ;
            CGPoint P2 = CGPointMake(0, 100) ;
            CGPoint P1 = CGPointMake(self.view.center.x, height) ;
            //确定曲线最低点
            CGPoint P = CGPointMake(0.25*(P0.x+P2.x)+0.5*P1.x, 0.25*(P0.y+P2.y)+0.5*P1.y) ;
            
            //火箭在曲线最低点上方(火箭在下拉状态)
            if(self.rockerLayer.dragDown == YES){
                CABasicAnimation * animation = [CABasicAnimation animation] ;
                animation.keyPath = @"position" ;
                animation.duration = 0.1f ;
                animation.toValue = [NSValue valueWithCGPoint:CGPointMake(P.x, P.y - 32)] ;
                [self.rockerLayer addAnimation:animation forKey:nil] ;
                [self.rockerLayer setPosition:CGPointMake(P.x, P.y -32)] ;
            }
        }
//    if(self.rockerLayer.dragDown == YES){
        [path closePath] ;
        self.shapeLayer.path = path.CGPath ;
//    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //设置火箭状态
    self.rockerLayer.dragDown = NO ;
    CGPoint currentCenterPoint = [self.scrollView.panGestureRecognizer locationInView:self.scrollView] ;
    
    //手指位置圆点
    UIBezierPath * path = [UIBezierPath bezierPath] ;
    [path moveToPoint:CGPointMake(currentCenterPoint.x, currentCenterPoint.y - 40)] ;
    [path addArcWithCenter:currentCenterPoint radius:15.0 startAngle:- M_PI_2 endAngle:M_PI * 1.5 clockwise:YES] ;
    self.circleLayer.path = path.CGPath ;
    //取消抖动
    [self.rockerLayer removeAnimationForKey:@"Jitter"] ;
    
    //火箭飞天
    CABasicAnimation * fly = [CABasicAnimation animation] ;
    fly.keyPath = @"position" ;
    fly.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, -32)] ;
    fly.duration = 0.06f ;
    fly.removedOnCompletion = NO ;
    fly.fillMode = kCAFillModeForwards ;
    fly.delegate = self ;
    [self.rockerLayer addAnimation:fly forKey:@"fly"] ;
    [self.rockerLayer setPosition:CGPointMake(self.view.center.x, -32)] ;
    //小圈圈出现（bug
    [self setCirclesWithFrame:CGRectMake(0, 0, self.view.width, 100)] ;
    
    //手势圆圈fade
    CABasicAnimation * animation = [CABasicAnimation animation] ;
    animation.keyPath = @"fillColor" ;
    animation.toValue = (id)[UIColor clearColor].CGColor ;
    animation.duration = 1.5f ;
    animation.removedOnCompletion = NO ;
    animation.fillMode = kCAFillModeForwards ;
    [self.circleLayer addAnimation:animation forKey:nil] ;
    self.circleLayer = nil ;
    
    if(self.scrollView.contentOffset.y < -100){
        [self.scrollView setContentOffset:CGPointMake(0, -100) animated:YES] ;
//        CASpringAnimation * animation = [CASpringAnimation animationWithKeyPath:@"path"] ;
//        UIBezierPath * path = [UIBezierPath bezierPath] ;
//        [path moveToPoint:CGPointMake(0, 0)] ;
//        [path addLineToPoint:CGPointMake(self.view.width, 0)] ;
//        [path addLineToPoint:CGPointMake(self.view.width, 100)] ;
//        [path addLineToPoint:CGPointMake(0, 100)] ;
//        [path closePath] ;
//
//        animation.toValue = (__bridge id _Nullable)(path.CGPath) ;
//        animation.damping = 5 ;
//        animation.stiffness = 100 ;
//        animation.initialVelocity = 0 ;
//        animation.duration = animation.settlingDuration ;
//        [self.shapeLayer addAnimation:animation forKey:@"spring"] ;
//        self.shapeLayer.path = path.CGPath ;
        
        
    }else if(self. scrollView.contentOffset.y < 0){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES] ;
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < -99 && scrollView.contentOffset.y > -101){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES] ;
            NSLog(@"%f",self.scrollView.contentOffset.y) ;
        });
    }
    else if(scrollView.contentOffset.y == 0){
        self.rockerLayer.dragDown = YES ;
    }
}

//火箭晃动处理
-(void)stateDetection{
    static CGPoint lastPoint ;
    if(!CGPointEqualToPoint(lastPoint, [self.scrollView.panGestureRecognizer locationInView:self.scrollView])){
        lastPoint = [self.scrollView.panGestureRecognizer locationInView:self.scrollView] ;
    }else if(self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        if(self.timer){
            [self rocketRotate] ;
            [self.timer invalidate] ;
            self.timer = nil ;
        }
    }
}
-(void)rocketRotate{
    //抖动
        CAKeyframeAnimation * keyFram = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"] ;
        
        //左晃偏移量
        NSNumber * leftNumber = [NSNumber numberWithFloat:- 0.15*M_PI] ;
        //原始位置
        NSNumber * originNumber = [NSNumber numberWithFloat:0] ;
        //右晃偏移量
        NSNumber * rightNumber = [NSNumber numberWithFloat: 0.15*M_PI] ;
        [keyFram setValues:@[originNumber, leftNumber, originNumber, rightNumber, originNumber]] ;
        keyFram.repeatCount = MAXFLOAT ;
        keyFram.repeatDuration = MAXFLOAT ;
        [self.rockerLayer addAnimation:keyFram forKey:@"Jitter"] ;
    
}
//animation完成代理
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([self.rockerLayer animationForKey:@"fly"] == anim){
        NSLog(@"finish") ;
        [self.rockerLayer removeAnimationForKey:@"fly"] ;
//        self.rockerLayer = nil ;
    }
    
    if([self.shapeLayer animationForKey:@"spring"] == anim){
        NSLog(@"spring") ;
    }
}

//随机创建火箭飞天后的小圆圈(并没有卵用
-(void)setCirclesWithFrame:(CGRect)frame{
    for(int i = 0 ; i < 5 ; i++){
        CGPoint center = CGPointMake(arc4random()%(int)frame.size.width, arc4random()%(int)frame.size.height) ;
        UIBezierPath * path = [UIBezierPath bezierPath] ;
        [path moveToPoint:CGPointMake(center.x, center.y - 20)] ;
        [path addArcWithCenter:center radius:15.0 startAngle:- M_PI_2 endAngle:M_PI * 1.5 clockwise:YES] ;
        
        CAShapeLayer * newLayer = [CAShapeLayer layer] ;
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        newLayer.fillColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor ;
//        newLayer.fillColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:0.5].CGColor ;
        newLayer.path = path.CGPath ;
        NSLog(@"%@",newLayer.fillColor) ;
        NSLog(@"%@",newLayer.path) ;
        
        [self.shapeLayer addSublayer:newLayer] ;
        [self.circleArr addObject:newLayer] ;
    }
    NSArray * cirArr = [NSArray arrayWithArray:self.circleArr] ;
    for(CAShapeLayer * layer in cirArr){
//        CAAnimationGroup * group = [CAAnimationGroup animation] ;
        CABasicAnimation * fade = [CABasicAnimation animationWithKeyPath:@"fillColor"] ;
        fade.toValue = (id)[UIColor clearColor].CGColor ;
        fade.duration = 2.f ;
        fade.removedOnCompletion = NO ;
        fade.fillMode = kCAFillModeForwards ;
        [layer addAnimation:fade forKey:nil] ;
        
    }
    for(CAShapeLayer * layer in self.circleArr){
        [layer removeFromSuperlayer] ;
    }
    [self.circleArr removeAllObjects] ;
}

@end
