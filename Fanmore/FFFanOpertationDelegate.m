//
//  FFFanOpertationDelegate.m
//  Fanmore
//
//  Created by Cai Jiang on 1/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FFFanOpertationDelegate.h"

@interface FFFanOpertationDelegate()

@property(weak) FFCircularProgressView* view;

@end

@implementation FFFanOpertationDelegate 

#pragma 初始化

+(id)DelegateForFFCircularProgressView:(FFCircularProgressView*)view{
    return [[FFFanOpertationDelegate alloc]initWithFFCircularProgressView:view];
}
-(id)initWithFFCircularProgressView:(FFCircularProgressView*)view{
    self = [super init];
    self.view = view;
    return self;
} 

#pragma FanOpertationDelegate实现
-(void)foStartSpin{
    [self.view startSpinProgressBackgroundLayer];
}

-(void)foStopSpin{
    [self.view stopSpinProgressBackgroundLayer];
}

-(void)foSetProgress:(CGFloat)progress{
    self.view.progress = progress;
}

-(void)foSetLineWidth:(CGFloat)lineWidth{
    self.view.lineWidth = lineWidth;
}
-(void)foSetTintColor:(UIColor*)color{
    self.view.tintColor = color;
}

@end
