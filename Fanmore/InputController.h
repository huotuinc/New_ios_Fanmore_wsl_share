//
//  InputController.h
//  Fanmore
//
//  Created by Cai Jiang on 3/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICallbacks.h"

@interface InputController : UIViewController
- (IBAction)doCancelled:(id)sender;
- (IBAction)doDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

+(void)popInputView:(UIViewController*)presenter view:(UIView*)view worker:(CB_Done)worker canceller:(CB_Cancelled)canceller;
-(void)dataView:(UIView*)view cbs:(UICallbacks*)cbs;

@end
