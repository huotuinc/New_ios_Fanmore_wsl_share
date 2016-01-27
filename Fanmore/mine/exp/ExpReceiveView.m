//
//  ExpReceiveView.m
//  Fanmore
//
//  Created by Cai Jiang on 10/22/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ExpReceiveView.h"
#import "AppDelegate.h"


@implementation ExpReceiveView

+(instancetype)showView:(NSNumber*)exp{
    ExpReceiveView* view = [[NSBundle mainBundle] loadNibNamed:@"ExpReceiveView" owner:nil options:nil][0];
    
#ifdef FanmoreDebug
    
#endif
    
    UIViewController* vc = [[[[AppDelegate getInstance] currentController] viewControllers] lastObject];
    
    [view.labelExp setText:$str(@"+%@",exp)];
    [view setFrame:CGRectMake(0, 0, 120, 65)];
    
    [vc.view addSubview:view];
    [view centerIn:vc.view.frame.size as:view.frame.size];
    
    view.layer.cornerRadius = 10.0f;
    view.layer.opacity = 0;
    
    __weak ExpReceiveView* wview = view;
    
    [wview performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:4];
    
    [UIView animateWithDuration:0.3 animations:^{
        wview.layer.opacity = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            //UIViewAnimationOptionBeginFromCurrentState
            [UIView animateWithDuration:0.2 delay:2.0 options:0 animations:^{
                [wview offset:0 y:10];
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.5 animations:^{
                        [wview offset:0 y:-700];
                        wview.layer.opacity = 0;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [wview removeFromSuperview];
                        }
                    }];
                }
            }];
        }
    }];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
