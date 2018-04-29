//
//  CARocketLayer.h
//  Refresh_rocket
//
//  Created by 张储祺 on 2018/4/29.
//  Copyright © 2018年 张储祺. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CARocketLayer : CAShapeLayer
//状态 判断火箭是下拉过程还是上升过程
@property(nonatomic, assign) BOOL dragDown;

@end
