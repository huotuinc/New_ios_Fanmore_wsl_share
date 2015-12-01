//
//  FakeNavigationBar.m
//  Fanmore
//
//  Created by Cai Jiang on 6/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FakeNavigationBar.h"

@implementation FakeNavigationBar

-(id)initWithController:(UIViewController*)controller{
    self = [super initWithFrame:CGRectMake(0, 20, 320, 44)];
    if (self) {
        self.backgroundColor = fmMainColor;
//        self.backgroundColor = [UIColor blueColor];
        // Initialization code
        
        //5 6; 57 30
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        button.frame = CGRectMake(5, 6, 57, 30);
        [button addTarget:controller action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        CGSize size = [controller.navigationItem.title sizeWithFont:[UIFont boldSystemFontOfSize:[UIFont labelFontSize]+1.0f]];
        // 中间一个  左侧一个
        CGFloat x = (self.frame.size.width-size.width)/2.0f;
        CGFloat y =(self.frame.size.height-size.height)/2.0f;
        
        //self.frame.origin.y+
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, size.width, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]+1.0f];
        label.text = controller.navigationItem.title;
        label.textColor = [UIColor whiteColor];
//        LOG(@"mylabel %@",label);
        [self addSubview:label];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
