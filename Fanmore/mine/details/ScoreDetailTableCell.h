//
//  ScoreDetailTableCell.h
//  Fanmore
//
//  Created by Cai Jiang on 6/13/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"
#import "ScorePerDay.h"

@interface ScoreDetailTableCell : FmTableCell

@property(nonatomic) BOOL focuxed;
-(void)configureDay:(ScorePerDay*)day index:(NSInteger)index;

@end
