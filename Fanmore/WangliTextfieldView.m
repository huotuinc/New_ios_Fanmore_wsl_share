//
//  WangliTextfieldView.m
//  Fanmore
//
//  Created by Cai Jiang on 12/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "WangliTextfieldView.h"

@interface WangliTextfieldView ()

@property(weak) UIImageView* b1;
@property(weak) UIImageView* b2;

@end

@implementation WangliTextfieldView

-(void)setLines:(NSUInteger)lines{
    _lines = lines;
    if (lines<=0) {
        return;
    }
    //304
    
    CGFloat pices = lines+1;
    CGFloat per = self.frame.size.height/pices;
    
    for (int i=0; i<lines; i++) {
        UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(16, per*(i+1), 304, .5f)];
        image.image = [UIImage imageNamed:@"hengAAAAAA"];
        [self addSubview:image];
    }
    
}

-(void)didMoveToSuperview{
    [self.b1 removeFromSuperview];
    [self.b2 removeFromSuperview];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, .5f)];
    image.image = [UIImage imageNamed:@"hengAAAAAA"];
    
    [self addSubview:image];
    self.b1 = image;
    
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, 320, .5f)];
    image.image = [UIImage imageNamed:@"hengAAAAAA"];
    
    [self addSubview:image];
    self.b2 = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
