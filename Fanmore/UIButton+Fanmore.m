//
//  UIButton+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 10/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UIButton+Fanmore.h"

@implementation UIButton (Fanmore)

-(UIButton*)cloneButton:(UIView*)view{
    UIButton* bt = [[UIButton alloc] initWithFrame:self.frame];
    [bt setTitle:self.currentTitle forState:UIControlStateNormal];
    [bt setTitleColor:self.currentTitleColor forState:UIControlStateNormal];
    [bt setTitleShadowColor:self.currentTitleShadowColor forState:UIControlStateNormal];
    [bt setBackgroundImage:self.currentBackgroundImage forState:UIControlStateNormal];
    [bt setImage:self.currentImage forState:UIControlStateNormal];
    return bt;
}

@end
