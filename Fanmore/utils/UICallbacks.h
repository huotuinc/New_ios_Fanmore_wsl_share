//
//  UICallbacks.h
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CB_Done)(id input);
typedef void(^CB_Cancelled)();
typedef BOOL(^CB_Dismiss)();
typedef void(^CB_Dismiss_BKSupport)(CB_Done done);

@interface UICallbacks : NSObject

@property(readonly) CB_Done done;

/**
 *  按照逻辑功能初始化回call
 *
 *  @param done      <#done description#>
 *  @param cancelled <#cancelled description#>
 *  @param dismiss   <#dismiss description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)callback:(CB_Done)done cancelled:(CB_Cancelled)cancelled dismiss:(CB_Dismiss)dismiss;
+(instancetype)callback:(CB_Done)done cancelled:(CB_Cancelled)cancelled dismissbk:(CB_Dismiss_BKSupport)dismissbk;

/**
 *  执行完成
 *  在完成之前 应当先行执行dismiss 并且取消cancel的回call
 *
 *  @param input <#input description#>
 */
-(void)invokeDone:(id)input;

/**
 *  主动调用取消
 *  同样应当先行执行dismiss 然后cancel 之前可以将done置空
 */
-(BOOL)invokeCancel;

/**
 *  界面变化导致相关view被关闭 这个时候也应当执行dismiss 然后执行cancelled
 */
-(BOOL)uidismiss;


@end
