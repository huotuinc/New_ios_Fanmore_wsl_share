//
//  FollowerListController.h
//  Fanmore
//
//  Created by Cai Jiang on 7/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AppDelegate (FollowerInfo)

/**
 *  最后一次保存的徒弟数
 *
 *  @return <#return value description#>
 */
-(NSNumber*)getNumberOfFollowers;
/**
 *  大概下面那个controller以后 就保存下哦
 *
 *  @param number <#number description#>
 */
-(void)saveNumberOfFollowers:(NSNumber*)number;

@end

@interface FollowerListController : UIViewController<UITableViewDataSource,UITableViewDelegate>

+(instancetype)pushFollowers:(UIViewController*)controller;

@end
