//
//  ScoreDetailComment.h
//  Fanmore
//
//  Created by Cai Jiang on 6/19/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreDetailComment : UIView

/**
 *  按照给予的背景和文字进行绘图
 *  并且返回 它所占用的大小
 *  调用者可以据此设定frame
 *
 *  @param side
 *  @param text       <#text description#>
 *
 *  @return 如果数据无效 则返回NULL或者0,0
 */
-(CGSize)draw:(BOOL)side text:(NSArray*)text;

@end
