//
//  LocatedHelper.m
//  Fanmore
//
//  Created by Cai Jiang on 7/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LocatedHelper.h"



@implementation AppDelegate (LocatedHelper)

-(void)logicRelogin{
    AppDelegate* ad = [AppDelegate getInstance];
    [[ad getFanOperations] login:nil block:^(LoginState *state, NSError *error) {
        
    } userName:[ad getLastUsername] password:[ad getLastPassword]];
}
/**
 *  保存地理位置
 *
 *  @param location <#location description#>
 */
-(void)saveCLLocation:(CLLocation*)location{
    self.preferences[@"saveCLLocationlatitude"] = $double(location.coordinate.latitude);
    self.preferences[@"saveCLLocationlongitude"] = $double(location.coordinate.longitude);
    [self savePreferences];
}
/**
 *  获取地理位置
 *
 *  @return <#return value description#>
 */
-(CLLocationCoordinate2D)getLocation{
    CLLocationCoordinate2D c2d;
    c2d.longitude = 0;
    c2d.latitude = 0;
    if (self.preferences[@"saveCLLocationlatitude"] && self.preferences[@"saveCLLocationlongitude"]) {
        c2d.latitude = [self.preferences[@"saveCLLocationlatitude"] doubleValue];
        c2d.longitude = [self.preferences[@"saveCLLocationlongitude"] doubleValue];
    }else{
        NSNumber* failed = self.preferences[@"LocatingFailedTime"];
        if($safe(failed) && [failed intValue]>=5){
            CLLocationCoordinate2D c22d;
            c22d.longitude = -1;
            c22d.latitude = -1;
            return c22d;
        }
    }
    return c2d;
}

@end


@implementation LocatedHelper

-(void)handleCitycode:(CLLocation*)location citycode:(CityCode)citycode{
    //如果当时已登录 则静默重新登录
    //反之仅仅保存就可以了
    
    AppDelegate* ad = [AppDelegate getInstance];
    if (citycode==-1){
        NSNumber* failed = ad.preferences[@"LocatingFailedTime"];
        if(!$safe(failed)){
            failed = @0;
        }
        failed = $int([failed intValue]+1);
        ad.preferences[@"LocatingFailedTime"] = failed;
        [ad savePreferences];
    }else{
        ad.preferences[@"LocatingFailedTime"] = @0;
        [ad savePreferences];
    }
    
    if (location) {
        [ad saveCLLocation:location];
        
        if([[AppDelegate getInstance].loadingState hasLogined]){
            [ad logicRelogin];
        }
    }
    
}

@end


