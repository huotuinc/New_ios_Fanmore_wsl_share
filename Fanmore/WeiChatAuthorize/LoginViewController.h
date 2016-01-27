//
//  LoginViewController.h
//  Fanmore
//
//  Created by lhb on 15/12/4.
//  Copyright © 2015年 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

/**
 *  1、  手机
    2、  微信
 */
@property(nonatomic,assign) int callType;


@property(nonatomic,copy)NSString *PhoneNumber;


@property(nonatomic,copy)NSString *codeNumber;
@end
