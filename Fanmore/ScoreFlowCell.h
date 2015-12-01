//
//  ScoreFlowCell.h
//  Fanmore
//
//  Created by Cai Jiang on 3/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"
#import "ScoreFlow.h"

@interface ScoreFlowCell : FmTableCell

-(void)configScoreFlow:(ScoreFlow*)flow index:(NSIndexPath*)index detail:(BOOL)detail;
@property (weak, nonatomic) IBOutlet UILabel *labelId;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UIImageView *imageType;
@property (weak, nonatomic) IBOutlet UIImageView *imageFlag;

@end
