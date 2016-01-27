//
//  UITableView+SetNoDateBackImage.m
//  Fanmore
//
//  Created by lhb on 16/1/13.
//  Copyright © 2016年 Cai Jiang. All rights reserved.
//

#import "UITableView+SetNoDateBackImage.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height //屏幕宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width   //屏幕高度

@implementation UITableView (SetNoDateBackImage)

- (void)setClearBackground {
    if (ScreenWidth == 375) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg375x667"]];
    }
    if (ScreenWidth == 414) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg621x1104"]];
    }
    if (ScreenWidth == 320) {
        if (ScreenHeight <= 480) {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg320x480"]];
        }else {
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbg320x568"]];
        }
    }
}

@end
