//
//  LocatedHelper.h
//  Fanmore
//
//  Created by Cai Jiang on 7/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface LocatedHelper : NSObject<CitycodeHandler>

@end

@interface AppDelegate (LocatedHelper)

/**
 *  重登录
 */
-(void)logicRelogin;
/**
 *  保存地理位置
 *
 *  @param location <#location description#>
 */
-(void)saveCLLocation:(CLLocation*)location;
/**
 *  获取地理位置
 *
 *  @return <#return value description#>
 */
-(CLLocationCoordinate2D)getLocation;

@end
