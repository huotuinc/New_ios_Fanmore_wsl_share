//
//  ForgotPswdController.h
//  Fanmore
//
//  Created by Cai Jiang on 4/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerificationCodeController.h"
#import "ScoreFlowSelection.h"

@interface ForgotPswdController : VerificationCodeController<FlowSelected>

+(void)openForgotPswd:(UIViewController*)controller;
@property (weak, nonatomic) IBOutlet ScoreFlowSelection *labelAuto;
@property (weak, nonatomic) IBOutlet ScoreFlowSelection *labelMan;
@property (weak, nonatomic) IBOutlet UIView *viewAuto;
@property (weak, nonatomic) IBOutlet UITextField *textPswd;
@property (weak, nonatomic) IBOutlet UITextField *textPswd2;
- (IBAction)textEditDone:(UITextField *)sender;
- (IBAction)doSelector:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewMan;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtDone;
/**
 *
 
 尊敬的用户，您可以通过以下渠道联系我们的工作人员寻回您的密码。
 
 联系电话：400-1818-357
 
 客服1 小单 QQ:1169984133
 
 客服2 小董 QQ:421306323
 
 客服3 小何 QQ:550071343
 */
@property (weak, nonatomic) IBOutlet UIWebView *helpWebView;

@end
