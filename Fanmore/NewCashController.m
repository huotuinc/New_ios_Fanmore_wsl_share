//
//  NewCashController.m
//  Fanmore
//
//  Created by Cai Jiang on 12/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "NewCashController.h"
#import "AppDelegate.h"
#import "FMUtils.h"
#import "BlocksKit+UIKit.h"
#import "WebController.h"
#import "CreditWebViewController.h"

@interface NewCashController ()<RefreshStatusAble>

@property NSMutableArray* otherUis;

@end

@implementation NewCashController

-(void)refreshStatus{
    self.navigationController.navigationBarHidden = NO;
    [self reloadOtherInfo];
}

-(void)beforeDismissLoginFrame{
    self.navigationController.navigationBarHidden = NO;
}

-(void)clickStore{
    if (![[AppDelegate getInstance].loadingState hasLogined]) {
        [FMUtils afterLogin:@selector(clickStore) invoker:self];
        return;
    }
    
    __weak NewCashController* wself = self;
    
    [wself.view startIndicator];
    [[[AppDelegate getInstance] getFanOperations] moneyStoreURL:nil block:^(NSString *des, NSError *error) {
        [wself.view stopIndicator];
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        CreditWebViewController* wc = [[CreditWebViewController alloc] initWithUrl:des];
        //            WebController* wc = [WebController openURL:des];
        //            wc.navigationItem.title = @"购买商品";
        [wself.navigationController pushViewController:wc animated:YES];
    }];
}

-(void)viewAddStore:(CGFloat)y{
    
    __weak NewCashController* wself = self;
    y+=20.0f;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 320, 21)];
    label.backgroundColor = [UIColor clearColor];
    [label setText:@"钱包可购买以下商品"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.otherUis addObject:label];
    [self.view addSubview:label];
    
    //
    UIImageView* wh = [[UIImageView alloc] initWithFrame:CGRectMake(290-5, y+1-7, 35, 35)];
    wh.image= [UIImage imageNamed:@"question_back"];
    [self.view addSubview:wh];
    [self.otherUis addObject:wh];
    wh.userInteractionEnabled = YES;
    [wh bk_whenTapped:^{
        [FMUtils toRuleController:wself attach:@"#tixianmimi"];
    }];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, y+28, 320, 219)];
    image.image = [UIImage imageNamed:@"moneystore"];
    [self.view addSubview:image];
    [self.otherUis addObject:image];
    
    image.userInteractionEnabled = YES;
    [image bk_whenTapped:^{
        [wself clickStore];
    }];
    
}

-(void)clickHistory{
    if (![[AppDelegate getInstance].loadingState hasLogined]) {
        [FMUtils afterLogin:@selector(clickHistory) invoker:self];
        return;
    }
    [self performSegueWithIdentifier:@"history" sender:nil];
}

-(void)clickCash{
    if (![[AppDelegate getInstance].loadingState hasLogined]) {
        [FMUtils afterLogin:@selector(clickCash) invoker:self];
        return;
    }
    // 仅仅检查 2个事情 1是否正在提现  2 余额是否足够
    LoadingState* ls = [AppDelegate getInstance].loadingState;
    
    if ([ls.userData.score intValue]<[ls.changeBoundary intValue]){
        [FMUtils alertMessage:self.view msg:$str(@"最少%@积分才可以转入哦，亲！",ls.changeBoundary)];
        return;
    }
    
//    if ([ls.userData.lockScore intValue]>0) {
//        [FMUtils alertMessage:self.view msg:@"你的转入申请正在处理中。"];
//        return;
//    }
    
    //。转入操作将在1－3个工作日内完成!确定转入吗?
    __weak NewCashController* wself = self;
    
    [UIAlertView bk_showAlertViewWithTitle:@"转入钱包" message:$str(@"%@。转入操作将在1－3个工作日内完成!确定转入吗?",[ls.userData cashScoreHint]) cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex!=0) {
            [wself.view startIndicator];
            [[[AppDelegate getInstance] getFanOperations] cashWallet:nil block:^(NSString *result, NSError *error) {
                [wself.view stopIndicator];
                if ($safe(error)) {
                    [FMUtils alertMessage:wself.view msg:[error FMDescription]];
                    return;
                }
                
                [FMUtils alertMessage:wself.view msg:@"申请成功！" block:^{
                    [wself reloadOtherInfo];
                }];
            }];

        }
        
    }];
    
    
}

-(void)reloadOtherInfo{
    
    [self.otherUis makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.otherUis removeAllObjects];
    
    [self.view startIndicator];
    
    __weak NewCashController* wself = self;
    
    [[[AppDelegate getInstance] getFanOperations] mywallet:nil block:^(NSNumber *scoreLast, NSNumber *walletLast, NSString *des, NSDate *recordTime, NSString *recordDes, NSNumber *recordResult, NSString *recordResultDes, NSError *error) {
        [wself.view stopIndicator];
        if ($safe(error)) {
            [FMUtils alertMessage:wself.view msg:[error FMDescription]];
            return;
        }
        
        [wself.labelScore setText:[scoreLast currencyString:@"" fractionDigits:2]];
        [wself.labelMoney setText:[walletLast currencyString:@"￥" fractionDigits:2]];
        [wself.labelDesc setText:des];
        
        CGFloat y = wself.labelDesc.frame.origin.y + wself.labelDesc.frame.size.height;
        
        if ($safe(recordTime)) {
//            recordResultDes = @"处理中";
//            recordResult = @2;
            y+=20.0f;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 300, 21)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:14];
            [label setText:@"最近一条转入钱包记录："];
            [wself.view addSubview:label];
            [wself.otherUis addObject:label];
            y+= 23;
            
            UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 320, 1)];
            image.image = [UIImage imageNamed:@"hengxian"];
            [wself.view addSubview:image];
            [wself.otherUis addObject:image];
            y+=1;
            
            //30
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, 30)];
            
            view.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:11];
            [label setText:[recordTime fmStandString]];
            [view addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 120, 30)];
            label.font = [UIFont systemFontOfSize:11];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentRight;
            [label setText:recordDes];
            [view addSubview:label];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 50, 30)];
            label.font = [UIFont systemFontOfSize:13];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            [label setText:$str(@"(%@)",recordResultDes)];
            switch ([recordResult intValue]) {
                case 0:
                    label.textColor = [UIColor greenColor];
                    break;
                case 1:
                    label.textColor = [UIColor redColor];
                    break;
                case 2:
                    label.textColor = [UIColor orangeColor];
                default:
                    break;
            }
            [view addSubview:label];
            
            
            [wself.view addSubview:view];
            [wself.otherUis addObject:view];
            y+=30;
            
            image = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 320, 1)];
            image.image = [UIImage imageNamed:@"hengxian"];
            [wself.view addSubview:image];
            [wself.otherUis addObject:image];
            y+=1;
            
        }
        
        [wself viewAddStore:y];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewDidLoadFanmore];
    [self viewDidLoadGestureRecognizer];
    
    [self.labelScore setText:@""];
    [self.labelMoney setText:@""];
    
    self.navigationItem.title = @"钱包";
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(clickHistory)]];
    [self.buttonCash addTarget:self action:@selector(clickCash) forControlEvents:UIControlEventTouchUpInside];
    
    self.otherUis = [NSMutableArray array];
    
    [self reloadOtherInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
