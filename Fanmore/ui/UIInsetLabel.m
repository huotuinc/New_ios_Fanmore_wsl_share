//
//  UIInsetLabel.m
//  Fanmore
//
//  Created by Cai Jiang on 8/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UIInsetLabel.h"

@implementation UIInsetLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
