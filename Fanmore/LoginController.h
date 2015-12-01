//
//  LoginController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/24/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICallbacks.h"

@interface LoginController : UIViewController

@property UICallbacks* callbacks;
-(id)initWithNibAndCallback:(UICallbacks*)callback;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)doLogin:(id)sender;
- (IBAction)doRegister:(id)sender;
- (IBAction)textfield_did:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btlogin;
@property (weak, nonatomic) IBOutlet UIButton *btregister;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelForgot;
- (IBAction)clickExit:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelRegister;

@end
