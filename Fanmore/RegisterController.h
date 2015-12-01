//
//  RegisterController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/25/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICallbacks.h"
#import "VerificationCodeController.h"

@interface RegisterController : VerificationCodeController

@property UICallbacks* callbacks;
-(id)initWithNibAndCallback:(UICallbacks*)callback;
@property(weak) id relexController;
- (IBAction)textdone:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *btRegister;
@property (weak, nonatomic) IBOutlet UITextField *textMobileFull;
@property (weak, nonatomic) IBOutlet UITextField *textInvitationCode;
@property (weak, nonatomic) IBOutlet UILabel *labelNewbieHint;
@property (weak, nonatomic) IBOutlet UIImageView *imageQ;
@property (weak, nonatomic) IBOutlet UITextField *cpassword;
@property (weak, nonatomic) IBOutlet UILabel *registerPocilyLabel;

@end
