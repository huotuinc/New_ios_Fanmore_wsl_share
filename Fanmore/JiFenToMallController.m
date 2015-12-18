//
//  JiFenToMallController.m
//  Fanmore
//
//  Created by lhb on 15/12/15.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "JiFenToMallController.h"
#import "AppDelegate.h"
#import "LoginState.h"
#import "GlodMallUserModel.h"
#import "MJExtension.h"
#import "FMUtils.h"
@interface JiFenToMallController ()<UIAlertViewDelegate>
/**万事利积分*/
@property (weak, nonatomic) IBOutlet UILabel *scoreJifen;

@property (weak, nonatomic) IBOutlet UILabel *Mydes;


/**转到商城积分*/
@property (weak, nonatomic) IBOutlet UILabel *toMallJifen;
/**第一条记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *firstRecord;
/**xxx记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *toMakkJifen;


/**用户列表*/
@property (nonatomic,strong) NSArray * userList;

@end

@implementation JiFenToMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小金库";
    
    //获取用户列表
    [self toGetTheGlodToMallAccountList];
    
    
    
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
    self.scoreJifen.text = [NSString stringWithFormat:@"%ld",(long)[a.score integerValue]];
    __weak JiFenToMallController * wself = self;
    [[[AppDelegate getInstance]  getFanOperations] TOGetGlodDate:nil block:^(NSDictionary *result, NSError *error) {
        wself.Mydes.text = [NSString stringWithFormat:@" %@",result[@"desc"]];
        wself.toMallJifen.text = [NSString stringWithFormat:@"%d",[result[@"money"] integerValue]];
        wself.firstRecord.text = result[@"lastApply"][@"ApplyTime"];
        wself.toMakkJifen.text = [NSString stringWithFormat:@"转入钱包%.2f元",[result[@"lastApply"][@"ApplyMoney"] doubleValue]];
        LOG(@"---%@--------%@",result,error.description);
    } WithParam:[NSString stringWithFormat:@"%d",[a.score integerValue]]];
}


/**
 *  获取用户列表
 */
- (void)toGetTheGlodToMallAccountList{
    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
    __weak JiFenToMallController * wself = self;
    [[[AppDelegate getInstance]  getFanOperations] TOGetUserList:nil block:^(id result, NSError *error) {
        if (result) {
           NSArray * UserList = [GlodMallUserModel objectArrayWithKeyValuesArray:result];
            if (UserList.count) {
                wself.userList = UserList;
            }
        }
    } WithunionId:a.unionId];
}

/**
 *  积分兑换
 *
 *  @param sender <#sender description#>
 */
- (IBAction)DuiHanJifen:(id)sender {
    
    
    if ([self.toMallJifen.text integerValue] <= 0) {
        [FMUtils alertMessage:self.view msg:@"当前积分不足"];
        return;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
    
    
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //得到输入框
    UITextField *tf = [alertView textFieldAtIndex:0];
    
    NSString *regex = @"^[0-9]";
    
    
    __weak JiFenToMallController * wself = self;
    GlodMallUserModel * usmodel = self.userList[0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
    
    NSString * passwd =  a.loginCode;
    NSArray * arra =  [passwd componentsSeparatedByString:@"^"];
    
    
    
    if (![predicate evaluateWithObject:tf.text]) {
        [[[AppDelegate getInstance]  getFanOperations] ToChangeJifenToMyBackMall:nil block:^(id result, NSError *error) {
            LOG(@"xxxxxx－－%@",result);
            if (result) {
                wself.scoreJifen.text = @"0";
                wself.toMallJifen.text = @"0";
            }
        } WithunionId:[NSString stringWithFormat:@"%@",a.score] withCashpassword:tf.text withMallUserId:[NSString stringWithFormat:@"%@",usmodel.userid] WithUserName:arra[0] withPassword:arra[1]];
        LOG(@"%@",tf.text);
    }else{
        
        [FMUtils alertMessage:self.view msg:@"请输入正确的积分值"];
    }
    
}

@end
