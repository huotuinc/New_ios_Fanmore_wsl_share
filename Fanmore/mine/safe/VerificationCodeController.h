//
//  VerificationCodeController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServicePolicyLabel.h"
#import "StandCash.h"

/**
 *  作为安全操作的起始入口都是需要获取验证码
 */
@interface VerificationCodeController : UIViewController<CashStepController>

@property int type;
@property (weak, nonatomic) IBOutlet UITextField *textCode;
@property (weak, nonatomic) IBOutlet UITextField *textMobile;
- (IBAction)textEditDone:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btGetCode;
@property (weak, nonatomic) IBOutlet ServicePolicyLabel *labelPocily;
@property (weak, nonatomic) IBOutlet UIButton *policySelected;
@property (weak, nonatomic) IBOutlet UITextField *textalbAccount;
@property (weak, nonatomic) IBOutlet UITextField *textalbName;
- (IBAction)okAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barbtok;

@end

@interface VCBindingALB : VerificationCodeController
@end

@interface VCBindingMobile : VerificationCodeController
@end

@interface VCUnbindingMobile : VerificationCodeController
@end