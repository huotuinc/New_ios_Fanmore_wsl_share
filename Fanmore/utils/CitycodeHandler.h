//
//  CitycodeHandler.h
//  Fanmore
//
//  Created by Cai Jiang on 2/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CitycodeHandler <NSObject>

-(void)handleCitycode:(CLLocation*)location citycode:(CityCode)citycode;

@end
