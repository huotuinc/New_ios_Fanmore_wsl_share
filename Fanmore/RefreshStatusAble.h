//
//  RefreshStatusAble.h
//  Fanmore
//
//  Created by Cai Jiang on 5/6/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RefreshStatusAble <NSObject>

-(void)refreshStatus;

@optional
/**
 *  在登录页面消失前调用
 */
-(void)beforeDismissLoginFrame;

@end
