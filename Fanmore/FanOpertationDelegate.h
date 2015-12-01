//
//  FanOpertationDelegate.h
//  Fanmore
//
//  the delegate which can watch the progresses of networking.
//
//  Created by Cai Jiang on 1/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FanOpertationDelegate <NSObject>

@optional

/**
 *  开始旋转
 */
-(void)foStartSpin;

/**
 *  停止旋转
 */
-(void)foStopSpin;

-(void)foSetProgress:(CGFloat)progress;
-(void)foSetLineWidth:(CGFloat)lineWidth;
-(void)foSetTintColor:(UIColor*)color;

@end
