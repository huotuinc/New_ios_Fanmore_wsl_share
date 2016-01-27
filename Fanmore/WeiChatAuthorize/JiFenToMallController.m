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
#import "MBProgressHUD+MJ.h"
#import "NSString+EXTERN.h"
@interface JiFenToMallController ()<UIAlertViewDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
/**万事利积分*/
@property (weak, nonatomic) IBOutlet UILabel *scoreJifen;

@property (weak, nonatomic) IBOutlet UILabel *Mydes;


/**转到商城积分*/
@property (weak, nonatomic) IBOutlet UILabel *toMallJifen;
/**第一条记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *firstRecord;
/**xxx记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *toMakkJifen;


/**记录展示的view*/
@property (weak, nonatomic) IBOutlet UIView *Record;

/**用户列表*/
@property (nonatomic,strong) NSMutableArray * userList;

/**遮罩*/
@property (nonatomic,strong) UIView * backView;
/**遮罩*/
@property (nonatomic,strong) UITableView * midtableView;
@end

@implementation JiFenToMallController


- (NSMutableArray *)userList{
    if (_userList == nil) {
        _userList = [NSMutableArray array];
    }
    return _userList;
}

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
    
    self.scoreJifen.text = [NSString stringWithFormat:@"%@",[NSString xiaoshudianweishudeal:[a.score floatValue]]];
    __weak JiFenToMallController * wself = self;
    [[[AppDelegate getInstance]  getFanOperations] TOGetGlodDate:nil block:^(id result, NSError *error) {
        
        LOG(@"xxxxxxxx%@",result);
        if(result[@"desc"]){
            wself.Mydes.text = [NSString stringWithFormat:@" 说明：%@",result[@"desc"]];
        }
        if(result[@"desc"]){
            LOG(@"000000000000%@",result[@"desc"]);
            wself.toMallJifen.text = [NSString stringWithFormat:@"%ld",[result[@"money"] integerValue]];
        }
        
        
        if (![result[@"lastApply"] isKindOfClass:[NSNull class]]) {
            if(result[@"lastApply"][@"ApplyTime"]){
                wself.firstRecord.text = result[@"lastApply"][@"ApplyTime"];
                wself.toMakkJifen.text = [NSString stringWithFormat:@"转入钱包%.2f元",[result[@"lastApply"][@"ApplyMoney"] doubleValue]];
                wself.Record.hidden = NO;
            }else{
                wself.Record.hidden = YES;
            }
        }else{
            wself.Record.hidden = YES;
        }
        LOG(@"---%@--------%@",result,error.description);
    } WithParam:[NSString stringWithFormat:@"%ld",(long)[a.score integerValue]]];
}


/**
 *  获取用户列表
 */
- (void)toGetTheGlodToMallAccountList{
    LoginState * a =  [AppDelegate getInstance].loadingState.userData;
    __weak JiFenToMallController * wself = self;
    [[[AppDelegate getInstance]  getFanOperations] TOGetUserList:nil block:^(id result, NSError *error) {
        NSLog(@"%@",result);
        if (result) {
           NSArray * UserList = [GlodMallUserModel objectArrayWithKeyValuesArray:result];
            if (UserList.count) {
                wself.userList = [NSMutableArray arrayWithArray:UserList];
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
    
    //多账号选择
    if (self.userList.count>1) {
        [self MildAlertView];
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
        
        [MBProgressHUD showMessage:nil];
        [[[AppDelegate getInstance]  getFanOperations] ToChangeJifenToMyBackMall:nil block:^(id result, NSError *error) {
            LOG(@"xxxxxx－－%@",result);
            if (result) {
                wself.scoreJifen.text = @"0";
                wself.toMallJifen.text = @"0";
            }
            
            [MBProgressHUD hideHUD];
        } WithunionId:[NSString stringWithFormat:@"%@",a.score] withCashpassword:tf.text withMallUserId:[NSString stringWithFormat:@"%@",usmodel.userid] WithUserName:arra[0] withPassword:arra[1]];
        LOG(@"%@",tf.text);
    }else{
        
        [FMUtils alertMessage:self.view msg:@"请输入正确的积分值"];
    }
    
}


/**账号提示*/

- (void)MildAlertView{
    
    UIView * backgroundView = [[UIView alloc] init];
    _backView = backgroundView;
    backgroundView.userInteractionEnabled = YES;
    backgroundView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width);
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
    [self.view.window insertSubview:backgroundView aboveSubview:self.view];
    
    
    
    
    CGFloat midTableH = 55 + 65 + (5>5?5:5) * 40;//
    _midtableView = [[UITableView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 200)/ 2, ([UIScreen mainScreen].bounds.size.height - midTableH) / 2, 200, midTableH) style:UITableViewStylePlain];
    _midtableView.dataSource = self;
    _midtableView.delegate = self;
    _midtableView.backgroundColor = [UIColor whiteColor];
    _midtableView.layer.cornerRadius = 10;
    _midtableView.scrollEnabled = NO;
    [backgroundView addSubview:_midtableView];
}

#pragma mark tableviewDatesource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        static NSString * ID1 = @"ID1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            cell.userInteractionEnabled = NO;
            cell.textLabel.text = @"商城账号选择";
        }
        return cell;
    }else{
        static NSString * ID1 = @"ID2";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            cell.userInteractionEnabled = YES;
                }
        
        
        
        
        return cell;
        
    }
    
    
}
@end
