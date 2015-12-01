//
//  ExpHistoryCell.m
//  Fanmore
//
//  Created by Cai Jiang on 10/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ExpHistoryCell.h"

@implementation NSDictionary (ExpHistory)

-(NSNumber*)getExpHistoryId{
    return self[@"id"];
}
-(NSNumber*)getExpHistoryAmount{
    return self[@"amount"];
}
-(NSString*)getExpHistoryReason{
    return self[@"reason"];
}
-(NSDate*)getExpHistoryDate{
    return [self[@"date"] fmToDate];
}

@end

@implementation ExpHistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(29, 10, 1, 49)];
    [iv setImage:[UIImage imageNamed:@"shuxian"]];
    [self addSubview:iv];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 28, 21)];
    [label setFont:[UIFont systemFontOfSize:10]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label];
    self.labelNo = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(38, 10, 224, 21)];
    [label setFont:[UIFont systemFontOfSize:20]];
    [self addSubview:label];
    self.labelName = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(38, 35, 224, 21)];
    [label setFont:[UIFont systemFontOfSize:11]];
    [label setTextColor:[UIColor darkGrayColor]];
    [self addSubview:label];
    self.labelDate = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(231, 11, 81, 50)];
    [label setFont:[UIFont systemFontOfSize:27]];
    [label setTextAlignment:NSTextAlignmentRight];
    [self addSubview:label];
    self.labelCount = label;
    
    return self;
}

-(void)config:(NSDictionary *)data row:(NSInteger)row{
    [self.labelName setText:[data getExpHistoryReason]];
    [self.labelDate setText:[[data getExpHistoryDate] fmStandString]];
    int x = [[data getExpHistoryAmount] intValue];
    [self.labelCount setText:$str(@"%@%d",x>0?@"+":@"",x)];
    
    [self.labelNo setText:$str(@"%d",row+1)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
