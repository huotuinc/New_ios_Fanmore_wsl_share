//
//  BugItemView.m
//  Fanmore
//
//  Created by Cai Jiang on 10/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "BugItemView.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "FMUtils.h"

@interface BugItemView ()

@property(weak) UIView* maskView;
@property(weak) NSDictionary* item;

@end

@implementation BugItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dismiss{
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)dobuy{
    __weak BugItemView* wself = self;
    LoginState* ls = [AppDelegate getInstance].loadingState.userData;
    int lastExp = [ls.exp intValue]-[[wself.item getAllItemPrice] intValue];
    if (lastExp<0) {
        [FMUtils alertMessage:self msg:@"您的经验不足以购买该道具。"];
        return;
    }
    [self startIndicator];
    [[[AppDelegate getInstance] getFanOperations] buyItem:nil block:^(NSArray *items, NSArray *myItems, NSError *error) {
        [wself stopIndicator];
        if ($safe(error)) {
            [FMUtils alertMessage:wself msg:[error FMDescription]];
            return;
        }
        
        [wself.handler itemsUpdate:items myItems:myItems];

        [FMUtils alertMessage:wself msg:@"购买成功！" block:^{
            [wself dismiss];
        }];
    } type:[self.item getAllItemType]];
}

-(void)show:(UIViewController*)controller item:(NSDictionary*)item{
    __weak BugItemView* wself = self;
    self.item = item;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithHexString:@"000" alpha:0.7];
    [view bk_whenTapped:^{
        [wself dismiss];
    }];
    [controller.view addSubview:view];
    self.maskView = view;
    
    [controller.view addSubview:self];
    [self centerIn:CGSizeMake(320, 450) as:CGSizeMake(248, 240)];
    self.layer.cornerRadius = 10;
    
    [self.imageItem setImage:[item getAllItemImage]];
    
    [self.labelDesc setText:[item getAllItemDesc]];
    [self.labelPrice setText:$str(@"消耗：%@经验",[item getAllItemPrice])];
    
    [self.buttonReturn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonGo addTarget:self action:@selector(dobuy) forControlEvents:UIControlEventTouchUpInside];
}

@end
