//
//  LoadingState+Ext.h
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoadingState.h"

@interface LoadingState (Ext)

/**
 *  是否展示该图片
 *  此方法会检查时间是否吻合
 *
 *  @return YES if current time in ShowTime
 */
-(BOOL)fmShowCurrent;

@end
