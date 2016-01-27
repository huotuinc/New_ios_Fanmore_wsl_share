//
//  UIViewController+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UIViewController+Fanmore.h"
#import "BlocksKit+UIKit.h"
#import "UIViewController+CWPopup.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

extern NSString const *CWBlurViewKey;

@interface AppDelegate (Guides)

/**
 *  检查是否需要显示这个向导
 *
 *  @param guide <#guide description#>
 *
 *  @return YES 表示需要显示
 */
-(BOOL)checkGuide:(NSString*)guide;
-(void)showedThisGuide:(NSString*)guide;

@end

@implementation AppDelegate (Guides)

-(BOOL)checkGuide:(NSString*)guide{
    NSArray* list = self.preferences[@"guides"];
    if (!$safe(list)) {
        return YES;
    }
    return ![list containsObject:guide];
}
-(void)showedThisGuide:(NSString*)guide{
    NSMutableArray* list = self.preferences[@"guides"];
    if (!list) {
        list = [NSMutableArray array];
        self.preferences[@"guides"] =list;
    }
    [list addObject:guide];
    [self savePreferences];
}

@end

@implementation UIViewController (Fanmore)

-(CGFloat)topY{
    //如果view 有y 则返回0
    //如果没有y 则根据nav 是否显示确定返回 0 or 64
    LOG(@"y:%f h:%f ",self.view.frame.origin.y, self.view.frame.size.height);
    
    if (self.view.frame.origin.y>0) {
        return 0;
    }
    if (self.navigationController.navigationBarHidden) {
        return 0;
    }
    return 64;
}

-(void)showGuide:(NSString*)imageName on:(UIView*)view{
    //@"guidsgdetail"
//luohaibo
    return;
#ifndef FanmoreDebug
    if (![[AppDelegate getInstance] checkGuide:imageName]) {
        return;
    }
#endif
    
    UIImageView* baseView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                [[UIScreen mainScreen] applicationFrame].size.width,
                                                                [[UIScreen mainScreen] applicationFrame].size.height+40)];
    //luohaibo
//    baseView.backgroundColor = [UIColor lightGrayColor];
        //self.view = baseView;
    if (!view) {
        view = self.navigationController.view;
    }
    
    view.backgroundColor = [UIColor redColor];
    [view addSubview:baseView];
    //[baseView setBackgroundColor:[UIColor blackColor]];
    //baseView.alpha = 0.7;
    baseView.userInteractionEnabled = YES;
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:baseView.frame];
    baseView.image = [UIImage imageNamed:imageName];
//    [baseView addSubview:imageView];
    //    baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//warning 2015年11/27 --luohaibo --- toFixit
    
    void(^callback)(BOOL) = [baseView bk_performBlock:^(id obj) {
        if ($safe(obj) && $safe([obj superview])) {
            [obj removeFromSuperview];
        }
    } afterDelay:1];


    [baseView bk_whenTapped:^{
        
        [baseView removeFromSuperview];
//        NSLog(@"xxx");
        callback(NO);
        callback(YES);
    }];
    
    [[AppDelegate getInstance] showedThisGuide:imageName];
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(id)up:(Class)clas{
    for (id c in self.navigationController.viewControllers) {
        if ([c isKindOfClass:clas]) {
            return c;
        }
    }
    return nil;
}

- (void)viewDidLoadFanmore{
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)]];
}

-(void)viewDidLoadGestureRecognizer{
    __weak UIViewController* wself = self;
    [self.view addGestureRecognizer:[UISwipeGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UISwipeGestureRecognizer* ssender = (UISwipeGestureRecognizer*)sender;
        if (ssender.direction==UISwipeGestureRecognizerDirectionRight){
            [wself doBack];
        }
    }]];
}

- (void)fmpresentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [self presentPopupViewController:viewControllerToPresent animated:flag completion:completion];
    UIView *blurView = objc_getAssociatedObject(self, &CWBlurViewKey);
    __weak UIViewController* wself = self;
    [blurView bk_whenTapped:^{
        [wself dismissPopupViewControllerAnimated:flag completion:NULL];
    }];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(BOOL)is35Inch{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    //480 568
    return !(height>480);
}

NSString const *FMVCFMNSNBO = @"FMVCFMNSNBO";

-(void)showNoshadowNavigationBar{
    objc_setAssociatedObject(self, &FMVCFMNSNBO, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNavigationBarHidden:NO];
    //    if (!self.tempImage) {
    //        self.tempImage = self.navigationController.navigationBar.shadowImage;
    //    }
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=7) {
        [self.navigationController.navigationBar setBackgroundImage:[self.class imageWithColor:fmMainColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
}


-(void)viewWillDisappear:(BOOL)animated{
    //    [self.navigationController.navigationBar setShadowImage:self.tempImage];
    NSNumber *no = objc_getAssociatedObject(self, &FMVCFMNSNBO);
    if (no && [no boolValue]) {
        LOG(@"check it back!!");
        self.navigationController.navigationBar.translucent = YES;
    }
}

@end
