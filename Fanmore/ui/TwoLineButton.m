//
//  TwoLineButton.m
//  Fanmore
//
//  Created by Cai Jiang on 7/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "TwoLineButton.h"

@interface TwoLineButton ()

@property NSString* upper;
@property NSString* setter;

@end

@implementation TwoLineButton

-(void)setTitles:(NSString*)upper setter:(NSString*)setter{
    self.upper = upper;
    self.setter = setter;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    return self;
}
//
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    if (!$safe(self.upper) || !$safe(self.setter))
//        return;
//    CGFloat fontSize = 19.0f;
//    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    CGRect viewBounds = rect;
//    CGContextTranslateCTM(ctx, 0, viewBounds.size.height);
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextSetRGBFillColor(ctx, 0.0, 1.0, 0.0, 1.0);
//    CGContextSetLineWidth(ctx, 2.0);
//    CGContextSelectFont(ctx, "Helvetica", 10.0, kCGEncodingMacRoman);
//    CGContextSetCharacterSpacing(ctx, 1.7);
//    CGContextSetTextDrawingMode(ctx, kCGTextFill);
//    CGContextShowTextAtPoint(ctx, 0, 0, "SOME TEXT", 9);
//}


@end
