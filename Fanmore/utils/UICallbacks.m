//
//  UICallbacks.m
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UICallbacks.h"

@interface UICallbacks ()

@property(readonly) CB_Dismiss dismisser;
@property(readonly) CB_Dismiss_BKSupport dismisser2;
@property(readonly) CB_Cancelled cancaller;

@end

@implementation UICallbacks

-(id)initWithCBS:(CB_Done)done cancelled:(CB_Cancelled)cancelled dismiss:(CB_Dismiss)dismiss{
    self = [super init];
    _dismisser = dismiss;
    _cancaller = cancelled;
    _done = done;
    return self;
}

-(id)initWithCBS:(CB_Done)done cancelled:(CB_Cancelled)cancelled dismissbk:(CB_Dismiss_BKSupport)dismissbk{
    self = [super init];
    _dismisser2 = dismissbk;
    _cancaller = cancelled;
    _done = done;
    return self;
}

+(instancetype)callback:(CB_Done)done cancelled:(CB_Cancelled)cancelled dismissbk:(CB_Dismiss_BKSupport)dismissbk{
    UICallbacks* cb = [[self alloc] initWithCBS:done cancelled:cancelled dismissbk:dismissbk];
    return cb;
}

+(instancetype)callback:(CB_Done)done cancelled:(CB_Cancelled)cancelled dismiss:(CB_Dismiss)dismiss{
    UICallbacks* cb = [[self alloc] initWithCBS:done cancelled:cancelled dismiss:dismiss];
    return cb;
}

-(void)cleanDone{
    _done = nil;
}
-(void)cleanCancel{
    _cancaller = nil;
}

-(BOOL)invokeDismiss:(CB_Done)block input:(id)input{
    
    if ($safe(self.dismisser2)) {
        self.dismisser2(block);
        _dismisser2 = nil;
    }
    
    if ($safe(self.dismisser)) {
        if(self.dismisser()){
            _dismisser = nil;
            block(input);
        }else
            return NO;
    }
    return YES;
}


/**
 *  执行完成
 *  在完成之前 应当先行执行dismiss 并且取消cancel的回call
 *
 *  @param input <#input description#>
 */
-(void)invokeDone:(id)input{
    _cancaller = nil;
    __weak UICallbacks* wself = self;
    [self invokeDismiss:^(id input) {
        if ($safe(wself.done)) {
            wself.done(input);
            [wself cleanDone];
        }
    } input:input];
    
}

/**
 *  主动调用取消
 *  同样应当先行执行dismiss 然后cancel 之前可以将done置空
 */
-(BOOL)invokeCancel{
    _done = nil;
    __weak UICallbacks* wself = self;
    return [self invokeDismiss:^(id input) {
        if ($safe(wself.cancaller)) {
            wself.cancaller();
            [wself cleanCancel];
        }
    } input:nil];
}

/**
 *  界面变化导致相关view被关闭 这个时候也应当执行dismiss 然后执行cancelled
 */
-(BOOL)uidismiss{
    return [self invokeCancel];
}


@end
