//
//  UIView+Fanmore.m
//  Fanmore
//
//  Created by Cai Jiang on 2/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "UIView+Fanmore.h"
#import <objc/runtime.h>

NSString const *FanmoreViewBadgeKey = @"FanmoreViewBadgeKey";
NSString const *FanmoreViewIndicatorKey = @"FanmoreViewIndicatorKey";

@implementation UIView (Fanmore)

+(instancetype)autoView:(UIView*)parent{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [parent addSubview:view];
    return view;
}

+(instancetype)autoView:(NSString*)name context:(LayoutContext*)context{
    UIView *view = [self autoView:context.parent];
    UIView* oldView = [context.views $for:name];
    if ($safe(oldView)) {
        [oldView removeFromSuperview];
    }
    [context addView:name view:view];
    return view;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG(@"began %@",self);
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    LOG(@"end %@",self);
//}

-(void)printInfo:(NSInteger)number{
    LOG(@"%2d %@",number,self);
    [self.subviews $each:^(id obj) {
        [obj printInfo:number+1];
    }];
}


-(void)startIndicator{
    [self stopIndicator];
    
    UIActivityIndicatorView* view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:view];
    
    [view centerIn:self.frame.size as:view.frame.size];
    [view startAnimating];
    
    objc_setAssociatedObject(self, &FanmoreViewIndicatorKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)stopIndicator{
    UIActivityIndicatorView* view = objc_getAssociatedObject(self, &FanmoreViewIndicatorKey);
    if (view) {
        [view stopAnimating];
        [view removeFromSuperview];
        objc_removeAssociatedObjects(view);
    }
}

#pragma mark - shake

-(void)shake:(CGFloat)range duration:(CFTimeInterval)duration count:(float)count{
    CALayer *lbl = [self layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-range, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+range, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:duration];
    [animation setRepeatCount:count];
    [lbl addAnimation:animation forKey:nil];
}

-(void)shake{
    [self shake:10.0 duration:0.1 count:3];
}

-(void)centerIn:(CGSize)parent as:(CGSize)size{
    [self setFrame:CGRectMake((parent.width-size.width)/2.0f, (parent.height-size.height)/2.0f, size.width, size.height)];
}

-(void)moveToY:(CGFloat)y{
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height)];
}

-(void)moveToX:(CGFloat)x{
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height)];
}

-(void)moveTo:(CGFloat)x y:(CGFloat)y{
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(x, y, frame.size.width, frame.size.height)];
}

-(void)offset:(CGFloat)x y:(CGFloat)y{
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x+x, frame.origin.y+y, frame.size.width, frame.size.height)];
}

-(void)hidenme{
    self.hidden = YES;
}
-(void)showme{
    self.hidden = NO;
}

-(void)badgeValue:(NSString *)badge{
    [self badgeValue:badge x:self.frame.size.width-6.0f y:-6.0f];
}

-(void)badgeValue:(NSString*)badge x:(CGFloat)x y:(CGFloat)y{
    // 应该保留一个引用 方便清除
    // 12 12
//    objc_setAssociatedObject(self, &CWBlurViewKey, blurView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel* label = objc_getAssociatedObject(self, &FanmoreViewBadgeKey);
    if (!badge && $safe(label)) {
        objc_setAssociatedObject(self, &FanmoreViewBadgeKey, nil, OBJC_ASSOCIATION_ASSIGN);
        [label removeFromSuperview];
        return;
    }
    
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y, 12, 12)];
        objc_setAssociatedObject(self, &FanmoreViewBadgeKey, label, OBJC_ASSOCIATION_ASSIGN);
        [self.superview addSubview:label];
    }
    
    [label setFrame:CGRectMake(self.frame.origin.x+x, self.frame.origin.y+y, 12, 12)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"badge"]];
    label.textColor = [UIColor whiteColor];
    
    CGFloat fontSize = 17.0f;
    while (true) {
        CGSize size = [badge sizeWithFont:[UIFont systemFontOfSize:fontSize]];
        if (size.width<label.frame.size.width-0.5 && size.height<label.frame.size.height-0.5) {
            break;
        }
        if (fontSize<=1.0f) {
            break;
        }
        fontSize -= 1;
    }
    
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    [label setText:badge];
}


@end
