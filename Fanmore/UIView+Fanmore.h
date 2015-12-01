//
//  UIView+Fanmore.h
//  Fanmore
//
//  Created by Cai Jiang on 2/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayoutContext.h"

@interface UIView (Fanmore)

+(instancetype)autoView:(UIView*)parent;
/**
 *  将根据上下文创建界面组件，并自动添加至上下文的界面组件中
 *
 *  @param name    在上下文中的唯一识别符 在上下文中重复的界面组件将从界面中移除
 *  @param context <#context description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)autoView:(NSString*)name context:(LayoutContext*)context;

-(void)printInfo:(NSInteger)number;

-(void)shake;

-(void)shake:(CGFloat)range duration:(CFTimeInterval)duration count:(float)count;

/**
 *  设置该view的frame让它以size的大小置中放入parent大小的父组件中
 *
 *  @param parent <#parent description#>
 *  @param size   <#size description#>
 */
-(void)centerIn:(CGSize)parent as:(CGSize)size;

-(void)offset:(CGFloat)x y:(CGFloat)y;
-(void)moveToX:(CGFloat)x;
-(void)moveToY:(CGFloat)y;
-(void)moveTo:(CGFloat)x y:(CGFloat)y;

-(void)hidenme;
-(void)showme;

/**
 *  在组件右上角 描绘一个badge
 *
 *  @param badeg <#badeg description#>
 */
-(void)badgeValue:(NSString*)badge;
/**
 *  在具体一个点描述badge
 *
 *  @param badge <#badge description#>
 *  @param x     相对于本组件的x
 *  @param y     相对于本组件的y
 */
-(void)badgeValue:(NSString*)badge x:(CGFloat)x y:(CGFloat)y;

/**
 *  开始Loading
 */
-(void)startIndicator;
/**
 *  停止Loading
 */
-(void)stopIndicator;
@end
