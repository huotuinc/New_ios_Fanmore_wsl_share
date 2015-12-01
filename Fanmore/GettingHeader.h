//
//  GettingHeader.h
//  Fanmore
//
//  Created by Cai Jiang on 6/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GettingHeader : UIView

/**
 更新
 scores将会被添加至list
 **/
-(void)updateScores:(NSArray*)scores max:(NSNumber*)max min:(NSNumber*)min;

/**
 高亮选择某日
 **/
-(void)selectDate:(NSDate*)date;

@end
