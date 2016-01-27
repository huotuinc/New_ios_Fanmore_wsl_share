//
//  MasterViewController.h
//  Fanmore
//
//  Created by Cai Jiang on 7/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

@property(weak) UILabel* labelCode;

/**
 *  打开师徒界面
 *  应该可以自动隐藏掉导航条 并且自己加入 收工导航按钮
 *
 *  @param controller <#controller description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)pushMaster:(UIViewController*)controller;

@end
