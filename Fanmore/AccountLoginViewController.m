//
//  AccountLoginViewController.m
//  Fanmore
//
//  Created by lhb on 15/12/18.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import "AccountLoginViewController.h"

@interface AccountLoginViewController ()

/**邀请码*/
@property (weak, nonatomic) IBOutlet UILabel *yaoQingMa;

/**手机号*/
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumber;

/**描述*/
@property (weak, nonatomic) IBOutlet UILabel *des;

/**登录点击*/
- (IBAction)LoginButtonClick:(id)sender;



@end

@implementation AccountLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)LoginButtonClick:(id)sender {
}
@end
