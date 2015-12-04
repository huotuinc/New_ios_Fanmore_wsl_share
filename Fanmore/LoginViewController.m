//
//  LoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//  邀请码注册控制器

#import "LoginViewController.h"

@interface LoginViewController ()

/**邀请码*/
@property (weak, nonatomic) IBOutlet UITextField *InviteCode;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    left.image = [UIImage imageNamed:@"TextField"];
    self.InviteCode.leftViewMode = UITextFieldViewModeAlways;
    self.InviteCode.leftView = left;
}



/**
 *  注册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)login:(id)sender {
    
    NSLog(@"xxxx");
}

@end
