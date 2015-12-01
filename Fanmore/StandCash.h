//
//  StandCash.h
//  Fanmore
//
//  Created by Cai Jiang on 6/20/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextChangeController.h"
#import "SafeController.h"


typedef void(^StepDoneCallBack)();


@protocol AbleStartCash <NSObject>

/**
 *  打开了其他页面准备cash
 */
-(void)beginOtherControllerForCash;

/**
 *  所有工作依然完成
 */
-(void)actionDone;

@end

@protocol CashStepController <NSObject>

/**
 *  寻找安全选项Controller
 *  如果能找到 说明并非step导致
 *  因为所有的提现步骤都在安全选项中完成
 *
 *  @return <#return value description#>
 */
-(SafeController*)findSafeController;

/**
 *  寻找发起提现的控制器
 *
 *  @return <#return value description#>
 */
-(UIViewController<AbleStartCash>*)mainCasher;

@end


@interface StandCash : TextChangeController<TextChangeDelegate>

+(StepDoneCallBack)iamDoneNext:(UIViewController<CashStepController>*)controller;

/**
 *  打开提现窗口
 *
 *  @param controller <#controller description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)pushStandCash:(UIViewController<AbleStartCash>*)controller;


@end
