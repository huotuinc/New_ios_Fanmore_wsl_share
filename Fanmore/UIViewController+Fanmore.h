//
//  UIViewController+Fanmore.h
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (Fanmore)

+ (UIImage *)imageWithColor:(UIColor *)color;

-(CGFloat)topY;

/**
 *  显示向导
 *
 *  @param imageName <#imageName description#>
 *  @param view      <#view description#>
 */
-(void)showGuide:(NSString*)imageName on:(UIView*)view;

/**
 *  在导航中寻找指定类别的controller
 *
 *  @param clas <#clas description#>
 *
 *  @return <#return value description#>
 */
-(id)up:(Class)clas;

-(void)doBack;
/**
 *  添加back按钮的样式
 */
- (void)viewDidLoadFanmore;
/**
 *  添加手势返回
 */
-(void)viewDidLoadGestureRecognizer;

/** 
 * 显示一个没有阴影 没有边框线的导航条
 */
-(void)showNoshadowNavigationBar;

-(BOOL)is35Inch;

- (void)fmpresentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end
