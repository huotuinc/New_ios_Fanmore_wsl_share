//
//  ServicePolicyLabel.m
//  Fanmore
//
//  Created by Cai Jiang on 3/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ServicePolicyLabel.h"

@implementation ServicePolicyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontSize =[self.text sizeWithFont:self.font forWidth:self.bounds.size.width lineBreakMode:NSLineBreakByTruncatingTail];
    
//    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);
    CGContextSetLineWidth(ctx, 1.0f);
    CGPoint l = CGPointMake(0, fontSize.height+2);
    CGPoint r = CGPointMake(fontSize.width, fontSize.height+2);
    
    CGContextMoveToPoint(ctx, l.x, l.y);
    CGContextAddLineToPoint(ctx, r.x, r.y);
    CGContextStrokePath(ctx);
}


@end
