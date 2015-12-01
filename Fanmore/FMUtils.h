//
//  FMUtils.h
//  Fanmore
//
//  Created by Cai Jiang on 1/13/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "SendTask.h"
#import "RefreshStatusAble.h"

@interface FMUtils : NSObject

typedef enum tagBorderType
{
    BorderTypeDashed,
    BorderTypeSolid
}BorderType;

typedef enum CashResultTye{
    CashResultNotEnoughScore,
    CashResultMobile,
    CashResultALP,
    CashResultPassword,
    CashResultOK,
} CashResultTye;


+(void)shareMyCash:(UIViewController*)controller;
+(CashResultTye)tryCash;

/**
 *  简单提交已转发事件
 *
 *  @param controller <#controller description#>
 *  @param task       <#task description#>
 *  @param type       <#type description#>
 *  @param callback   成功的回调 可以为NULL
 */
+(void)submitSendResult:(UIViewController<SendTask,ShareToolDelegate>*)controller task:(Task*)task type:(TShareType)type callback:(SuccessCallback)callback;
+(void)sendTask:(UIViewController<SendTask,ShareToolDelegate>*)controller;

+(void)favIconToogle:(UIImageView*)view fav:(BOOL)fav;
+(void)sendButtonsToggle:(UIViewController<SendTask>*)controller task:(Task *)task sent:(BOOL)sent hideAfterOnline:(BOOL)hideAfterOnline;
//+(void)sendButtonsToggle:(UIButton*)button qiangwan:(UIButton*)qiangwan yizhuanfa:(UIButton*)yizhuanfa task:(Task*)task sent:(BOOL)sent;
//+(void)sendButtonToggle:(UIButton*)button task:(Task*)task;
//+(void)sendButtonToggle:(UIButton*)button sent:(BOOL)sent;

+(NSInteger)sectionsByTaskTime:(NSArray*)tasks;
+(NSInteger)rowsBy:(NSArray*)tasks section:(NSInteger)section;
+(id)dataBy:(NSArray*)tasks section:(NSInteger)section andRow:(NSInteger)row;

+(NSInteger)sectionsByTaskTime:(NSArray*)tasks timeGetter:(NSString* (^)(id input))timeGetter;
+(NSInteger)rowsBy:(NSArray*)tasks section:(NSInteger)section  timeGetter:(NSString* (^)(id input))timeGetter;
+(id)dataBy:(NSArray*)tasks section:(NSInteger)section andRow:(NSInteger)row timeGetter:(NSString* (^)(id input))timeGetter;


/**
 *  确认这个文件的上级目录是存在的
 *
 *  @param file 文件的绝对路径
 *
 *  @return 就是file
 */
+(NSString*)makeSureParentDirectoryExisting:(NSString*)file;

+(NSString*)parentPath:(NSString*)path;

+(void)afterLogin:(SEL)after invoker:(UIViewController<RefreshStatusAble>*)invoker;
+(CGPoint)pointToRightTop:(UILabel*)label;

/**
 *  锁定在屏幕一方
 *
 *  @param direction 方向 UISwipeGestureRecognizerDirection
 *  @param rect      原来rect
 *  @param offset    偏移量
 *
 *  @return 不会改变size
 */
+(CGRect)lockAtScreen:(UISwipeGestureRecognizerDirection)direction  rect:(CGRect)rect offset:(CGFloat)offset;

+(MBProgressHUD*)alertMessage:(UIView*)parent msg:(NSString*)msg;
+(MBProgressHUD*)alertMessage:(UIView*)parent msg:(NSString*)msg block:(void (^)())block;

/**
 *  动画特效 在特定时间内 将变化Label上的数字
 *
 *  @param label    <#label description#>
 *  @param from     <#from description#>
 *  @param to       <#to description#>
 *  @param duration <#duration description#>
 */
+(void)dynamicIncreaseLabel:(UILabel*)label from:(NSNumber*)from to:(NSNumber*)to duration:(NSTimeInterval)duration formatter:(NSNumberFormatter*)formatter  random:(BOOL)random;
+(void)dynamicIncreaseLabel:(UILabel*)label from:(NSNumber*)from to:(NSNumber*)to duration:(NSTimeInterval)duration;

/**
 *  打开策略
 *
 *  @param attach 附加数据 比如锚点
 */
+(void)toPolicyController:(UIViewController*)controller attach:(NSString*)attach;
/**
 *  打开规则
 *
 *  @param attach 附加数据 比如锚点
 */
+(void)toRuleController:(UIViewController*)controller attach:(NSString*)attach;

+(void)toToolRuleController:(UIViewController*)controller attach:(NSString*)attach;

@end
