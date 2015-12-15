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

@interface JiFenToMallController ()
/**万事利积分*/
@property (weak, nonatomic) IBOutlet UILabel *scoreJifen;

@property (weak, nonatomic) IBOutlet UILabel *Mydes;


/**转到商城积分*/
@property (weak, nonatomic) IBOutlet UILabel *toMallJifen;
/**第一条记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *firstRecord;
/**xxx记录时间*/
@property (weak, nonatomic) IBOutlet UILabel *toMakkJifen;

@end

@implementation JiFenToMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小金库";
    
    
    
    
    
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
        
        wself.Mydes.text = result[@"desc"];
        wself.toMakkJifen.text = [NSString stringWithFormat:@"%d",[result[@"money"] integerValue]];
        wself.firstRecord.text = result[@"lastApply"][@"ApplyTime"];
        wself.toMakkJifen.text = [NSString stringWithFormat:@"转入钱包%.2f元",[result[@"lastApply"][@"ApplyMoney"] doubleValue]];
        LOG(@"---%@--------%@",result,error.description);
    } WithParam:[NSString stringWithFormat:@"%d",[a.score integerValue]]];
    
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
