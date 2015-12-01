//
//  UIViewController+MyPop.h
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString const *MyPopupKey;
extern NSString const *MyBlurViewKey;
extern NSString const *MyUseBlurForPopup;

@interface UIViewController (MyPop)


@property (nonatomic, readwrite) UIViewController *popupViewController;
@property (nonatomic, readwrite) BOOL useBlurForPopup;

- (void)presentMyPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissMyPopupViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
- (void)setUseBlurForPopup:(BOOL)useBlurForPopup;
- (BOOL)useBlurForPopup;


@end
