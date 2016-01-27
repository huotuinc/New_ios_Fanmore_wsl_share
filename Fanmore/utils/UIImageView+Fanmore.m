//
//  UIImageView+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 10/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UIImageView+Fanmore.h"

@implementation UIImageView (Fanmore)

-(UIImageView*)cloneImage:(UIView*)view{
    UIImageView* v = [[UIImageView alloc] initWithFrame:self.frame];
    [v setBackgroundColor:self.backgroundColor];
    [v setImage:self.image];
    [view addSubview:v];
    return v;
}

@end
