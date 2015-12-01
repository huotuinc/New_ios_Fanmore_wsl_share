//
//  ScoreFlowSelection.m
//  Fanmore
//
//  Created by Cai Jiang on 3/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ScoreFlowSelection.h"
#import "BlocksKit+UIKit.h"

@interface ScoreFlowSelection ()
@end

@implementation ScoreFlowSelection

-(void)activeSelection{
    __weak static ScoreFlowSelection* current;
    if ($safe(current)) {
        [current unactive];
        current = nil;
    }
    _actived = YES;
    current = self;
    [self setTextColor:[UIColor whiteColor]];
    [self setNeedsDisplay];
    if ($safe(self.delegate) && [self.delegate respondsToSelector:@selector(flowSelected:)]) {
        [self.delegate flowSelected:self];
    }
}

-(void)unactive{
    _actived = NO;
    [self setTextColor:[UIColor blackColor]];
    [self setNeedsDisplay];
}

-(void)myinit{
    __weak ScoreFlowSelection* wself = self;
    self.userInteractionEnabled = YES;
    [self bk_whenTapped:^{
        if (!wself.actived) {
            [wself activeSelection];
        }
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self myinit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self myinit];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.actived) {
        if ($safe(self.backgroundCColor)) {
            CGContextSetFillColorWithColor(context, self.backgroundCColor.CGColor);
            CGContextFillRect(context,rect);
        }else if ($safe(self.backgroundImageName)) {
            CGContextDrawImage(context, rect, [UIImage imageNamed:self.backgroundImageName].CGImage);
        }else{
            CGContextDrawImage(context, rect, [UIImage imageNamed:@"partin_detail_tab_on"].CGImage);
        }
    }else{
        CGContextDrawImage(context, rect, [UIImage imageNamed:@"partin_detail_tab_off"].CGImage);
    }
    
    
    [super drawRect:rect];
}


@end
