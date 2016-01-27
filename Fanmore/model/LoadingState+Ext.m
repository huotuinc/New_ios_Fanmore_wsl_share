//
//  LoadingState+Ext.m
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "LoadingState+Ext.h"
#import "NSString+Fanmore.h"
#import "NSDate+Fanmore.h"

@implementation LoadingState (Ext)

-(BOOL)fmShowCurrent{
    NSArray* dts = [self.loadingImg.showTime $split:@","];
    return [[NSDate date]between:[dts[0] fmToDate] end:[dts[1] fmToDate]];
}

@end
