//
//  DIYView.m
//  Fanmore
//
//  Created by Cai Jiang on 6/13/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "DIYView.h"

@implementation DIYView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


CGFloat _bc = 30.0f;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    //画3个点  然后fill
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    CGFloat baseY = -64;
    CGFloat baseY = 0;
    CGFloat height = _bc* sin(M_PI_4) / sin(M_PI_2);
    
    CGPoint sPoints[3];//坐标点
    sPoints[0] =CGPointMake(320.0f/2.0f-_bc/2.0f, baseY);//坐标1
    sPoints[1] =CGPointMake(320.0f/2.0f+_bc/2.0f, baseY);//坐标2
    sPoints[2] =CGPointMake(320.0f/2.0f, baseY+height);//坐标3
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextSetFillColorWithColor(context, [fmMainColor CGColor]);
    CGContextDrawPath(context, kCGPathFill); //根据坐标绘制路径
}


@end
