//
//  FollowerDetailController.h
//  Fanmore
//
//  Created by Cai Jiang on 7/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowerDetailController : UIViewController

/**
 *  打开详情
 *
 *  @param controller <#controller description#>
 *  @param follower   <#follower description#>
 *
 *  @return <#return value description#>
 */
+(instancetype)pushController:(UIViewController*)controller follower:(NSDictionary*)follower;

@end
