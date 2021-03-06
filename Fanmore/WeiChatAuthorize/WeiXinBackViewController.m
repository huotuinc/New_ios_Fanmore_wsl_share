//
//  WeiXinBackViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "WeiXinBackViewController.h"
#import "UserInfo.h"
#import "UserLoginTool.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"

@interface WeiXinBackViewController ()

/**微信头像*/
@property (weak, nonatomic) IBOutlet UIImageView *weiXInIconView;
/**微信用户名*/
@property (weak, nonatomic) IBOutlet UILabel *WeiXinUserName;


@end

@implementation WeiXinBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


- (void) setup{
    
    self.weiXInIconView.layer.cornerRadius = self.weiXInIconView.frame.size.height * 0.5;
    self.weiXInIconView.layer.masksToBounds = YES;
    self.weiXInIconView.layer.borderWidth = 2;
    self.weiXInIconView.layer.borderColor = [UIColor whiteColor].CGColor;
    NSString * filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * file = [filePath stringByAppendingPathComponent:WXQAuthBringBackUserInfo];
    UserInfo * user = [NSKeyedUnarchiver unarchiveObjectWithFile:file];

    NSLog(@"%@-----%@",user.headimgurl,user.nickname);
    [self.weiXInIconView sd_setImageWithURL:[NSURL URLWithString:user.headimgurl] placeholderImage:[UIImage imageNamed:@"WeiXinIIconViewDefaule"] options:SDWebImageRetryFailed];
    
    self.WeiXinUserName.text = user.nickname;
}

/**
 *  微信后注册
 *
 *  @param sender <#sender description#>
 */
- (IBAction)NetActionStep:(id)sender {
    LoginViewController * Register = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    Register.callType = _callType;
    Register.PhoneNumber = _PhoneNumber;
    Register.codeNumber = _codeNumber;
    [self.navigationController pushViewController:Register animated:YES];
   
}


@end
