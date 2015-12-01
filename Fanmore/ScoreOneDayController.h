//
//  ScoreOneDayController.h
//  Fanmore
//
//  Created by Cai Jiang on 6/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  显示一天收益的详情
 *  包括非任务的和任务的
 */
@interface ScoreOneDayController : UIViewController<UITableViewDataSource,UITableViewDelegate>
//@interface ScoreOneDayController : UITableViewController<UITableViewDataSource,UITableViewDelegate>


@property NSDate* date;

/**
 *  push到当前的navigationcontroller
 *
 *  @param date       指定日期 如果为nil则为昨日
 *  @param controller
 *
 *  @return <#return value description#>
 */
+(instancetype)pushScoreOneDay:(NSDate*)date on:(UIViewController*)controller;

@end
