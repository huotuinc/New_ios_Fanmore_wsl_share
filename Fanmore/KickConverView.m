//
//  KickConverView.m
//  Fanmore
//
//  Created by Cai Jiang on 10/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

// huisheguajiangqu 909090

#import "KickConverView.h"

@interface KickConverView ()
@property UIBezierPath* openeddPath;
@end


@implementation KickConverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        
        _sizeBrush = 10.0;
    }
    return self;
}

#pragma mark -
#pragma mark CoreGraphics methods

// Will be called every touch and at the first init
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage *imageToDraw = [UIImage imageWithCGImage:scratchImage];
    [imageToDraw drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
}

// Method to change the view which will be scratched
- (void)setHideView:(UIView *)hideView
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    float scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(hideView.bounds.size, NO, 0);
    [hideView.layer renderInContext:UIGraphicsGetCurrentContext()];
    hideView.layer.contentsScale = scale;
    hideImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
    
    size_t imageWidth = CGImageGetWidth(hideImage);
    size_t imageHeight = CGImageGetHeight(hideImage);
    
    bitmapBytesPerRow = (imageWidth * 4);
    bitmapByteCount = (bitmapBytesPerRow * imageHeight);
    
    CFMutableDataRef pixels = CFDataCreateMutable(NULL, imageWidth * imageHeight);
    contextMask = CGBitmapContextCreate(CFDataGetMutableBytePtr(pixels), imageWidth, imageHeight , 8, imageWidth, colorspace, 0);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(pixels);
    
    CGContextSetFillColorWithColor(contextMask, [UIColor blackColor].CGColor);
    CGContextFillRect(contextMask, self.frame);
    
    CGContextSetStrokeColorWithColor(contextMask, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(contextMask, _sizeBrush);
    CGContextSetLineCap(contextMask, kCGLineCapRound);
    
    CGImageRef mask = CGImageMaskCreate(imageWidth, imageHeight, 8, 8, imageWidth, dataProvider, nil, NO);
    scratchImage = CGImageCreateWithMask(hideImage, mask);
    
    CGImageRelease(mask);
    CGColorSpaceRelease(colorspace);
    
    [self initScratch];
    self.openeddPath = [UIBezierPath bezierPath];
    self.openeddPath.lineWidth = self.sizeBrush;
}

- (void)scratchTheViewFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    float scale = [UIScreen mainScreen].scale;
    
    [self.openeddPath moveToPoint:startPoint];
    [self.openeddPath addLineToPoint:endPoint];
    
    CGContextMoveToPoint(contextMask, startPoint.x * scale, (self.frame.size.height - startPoint.y) * scale);
    CGContextAddLineToPoint(contextMask, endPoint.x * scale, (self.frame.size.height - endPoint.y) * scale);
    CGContextStrokePath(contextMask);
    [self setNeedsDisplay];
    
    //answer对于view来说的rect!
    
    if (self.answerRect.size.width>0) {
        UIBezierPath* path = [UIBezierPath bezierPathWithCGPath:self.openeddPath.CGPath];
        path.lineWidth = self.sizeBrush;
        [path closePath];
        if (!CGRectContainsRect(path.bounds,self.answerRect)) {
            LOG(@"未包含");
            return;
        }
//        for (int x=0; x<self.answerRect.size.width; x++) {
//            for (int y=0; y<self.answerRect.size.height; y++) {
//                CGFloat xx = x;
//                CGFloat yy = y;
//                CGFloat xxx = xx+self.answerRect.origin.x;
//                CGFloat yyy = yy+self.answerRect.origin.y;
//                if (![path containsPoint:CGPointMake(xxx, yyy)]) {
//                    LOG(@"不包含 %f,%f",xxx,yyy);
//                    return;
//                }
//            }
//        }
    }
    LOG(@"全部挂开");
    [self.delegate answerGetted];
}

#pragma mark -
#pragma mark Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    currentTouchLocation = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    
    if (!CGPointEqualToPoint(previousTouchLocation, CGPointZero))
    {
        currentTouchLocation = [touch locationInView:self];
    }
    
    previousTouchLocation = [touch previousLocationInView:self];
    
    [self scratchTheViewFrom:previousTouchLocation to:currentTouchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [[event touchesForView:self] anyObject];
    
    if (!CGPointEqualToPoint(previousTouchLocation, CGPointZero))
    {
        previousTouchLocation = [touch previousLocationInView:self];
        [self scratchTheViewFrom:previousTouchLocation to:currentTouchLocation];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)initScratch
{
    currentTouchLocation = CGPointZero;
    previousTouchLocation = CGPointZero;
}

@end
