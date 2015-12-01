//
//  BugItemView.h
//  Fanmore
//
//  Created by Cai Jiang on 10/15/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemCell.h"

@interface BugItemView : UIView

@property(weak) id<ItemsKnowlege> handler;
@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIButton *buttonReturn;
@property (weak, nonatomic) IBOutlet UIButton *buttonGo;

-(void)show:(UIViewController*)controller item:(NSDictionary*)item;

@end
