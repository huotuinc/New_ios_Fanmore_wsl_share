//
//  UILabel+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 8/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UILabel+Fanmore.h"

@implementation UILabel (Fanmore)

-(UILabel*)cloneLabel:(UIView*)view{
    UILabel* l = [[UILabel alloc] initWithFrame:self.frame];
    [l setText:self.text];
//    [l setBackgroundColor:self.backgroundColor];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:self.textColor];
    [l setFont:self.font];
    [l setTextAlignment:self.textAlignment];
    [view addSubview:l];
    [self removeFromSuperview];
    return l;
}

-(void)wellFontFrom:(CGFloat)font{
    //17
    while (true) {
        CGSize size= [self.text sizeWithFont:[UIFont systemFontOfSize:font]];
        if (size.width<self.frame.size.width) {
            break;
        }
        font = font -1.0f;
    }
    [self setFont:[UIFont systemFontOfSize:font]];
}

@end
