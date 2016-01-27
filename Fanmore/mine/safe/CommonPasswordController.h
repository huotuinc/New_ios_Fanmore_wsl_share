//
//  CommonPasswordController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/28/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextChangeController.h"
#import "StandCash.h"

/**
 *  常规修改密码
 *  需要传入2个参数 以决定它的行为
 *  编辑类型  修改 还是设置
 *  密码类型  登录密码 还是提现密码
 */
@interface CommonPasswordController : UIViewController<CashStepController>

@property int editMode;
@property int passwordMode;
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIButton *btok;
@property (weak, nonatomic) IBOutlet UIButton *btcancel;
- (IBAction)doTextnext:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelForget;
- (IBAction)okAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barbtok;

@end

@interface PswdController : CommonPasswordController
@end

@interface CashPswdController : CommonPasswordController<TextChangeDelegate>
@end
