//
//  CashHistoryCell.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "CashHistoryCell.h"
#import "NSDate+Fanmore.h"
#import "AppDelegate.h"
#import "BlocksKit+UIKit.h"

@interface CashHistoryCell ()
//@property(weak) UILabel* extra;
//@property(weak) CashHistory* cash;
@end

@implementation CashHistoryCell

+(CGSize)sizeOfMessage:(NSString*)msg{
    // 17
    UIFont* font = [UIFont systemFontOfSize:17.0f];
    return [msg sizeWithFont:font constrainedToSize:CGSizeMake(320.0f, MAXFLOAT)];
//    return [msg sizeWithFont:font forWidth:320.0f lineBreakMode:NSLineBreakByCharWrapping];
}

-(void)configCashHistory:(CashHistory*)cash{
    
//    if (self.extra!=nil ) {
////        LOG(@"sub layout");
////        CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-CGRectGetHeight(self.extra.frame));
////        CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-CGRectGetHeight(self.extra.frame));
////        
////        self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
////        self.frame = newCellViewFrame;
//        [self.extra removeFromSuperview];
//        self.extra = nil;
//        LOG(@"just remove extra %@",self.extra);
//    }

    
    LOG(@"reconfig cash");
    self.idLabel.text = $str(@"%@",cash.showId);
    NSMutableAttributedString* money = [[NSMutableAttributedString alloc] initWithString:@"提现"];
    NSAttributedString* m2=[[NSAttributedString alloc]initWithString:$str(@"%@",cash.money) attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    NSAttributedString* m3 = [[NSAttributedString alloc]initWithString:@"元"];
    [money appendAttributedString:m2];
    [money appendAttributedString:m3];
    
    self.moneyLabel.attributedText = money;
    self.scoreLabel.text = $str(@"消耗%@个积分",cash.score);
    self.timeLabel.text = [cash.time fmStandString];
    self.statusLabel.attributedText = [cash statusLabel];
    
    if ($safe(cash.extraMsg) && [cash.extraMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length>0) {
        [self.labelExtra showme];
        CGSize size = [CashHistoryCell sizeOfMessage:cash.extraMsg];
        [self.labelExtra setFrame:CGRectMake(self.labelExtra.frame.origin.x, self.labelExtra.frame.origin.y, 320.0f, size.height)];
        [self.labelExtra setText:cash.extraMsg];
        [self setNeedsLayout];
    }else{
        [self.labelExtra hidenme];
    }
    
//    self.cash = cash;
    
}

//-(void)layoutSubviews {
//    LOG(@" do layoutsubew");
//    if ([self isSelected] && self.extra==nil && $safe(self.cash.extraMsg) && !$eql(self.cash.extraMsg,@"") ) {
//        LOG(@"extend layout");
//        UIFont* font = [UIFont systemFontOfSize:17.0f];
//        CGSize size = [self.cash.extraMsg sizeWithFont:font constrainedToSize:CGSizeMake(320.0f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
//        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, 320, size.height)];
//        [label setBackgroundColor:[UIColor redColor]];
//        label.textColor = [UIColor whiteColor];
//        label.text = self.cash.extraMsg;
//        label.textAlignment = NSTextAlignmentCenter;
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        label.font  = font;
//        label.numberOfLines = 200;
//        self.extra = label;
//        CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height+CGRectGetHeight(label.frame));
//        CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+CGRectGetHeight(label.frame));
//        
//        self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
//        self.frame = newCellViewFrame;
//        
//        [self addSubview:label];
//        
//        __weak CashHistoryCell* wself = self;
//        label.userInteractionEnabled = YES;
//        [label bk_whenTapped:^{
//            wself.selected = NO;
//            [wself layoutSubviews];
//        }];
//    }
//    
//    if (![self isSelected] && self.extra!=nil && self.frame.size.height > 67) {
//        LOG(@"sub layout");
//        CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-CGRectGetHeight(self.extra.frame));
//        CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height-CGRectGetHeight(self.extra.frame));
//        
//        self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
//        self.frame = newCellViewFrame;
//        [self.extra removeFromSuperview];
//        self.extra = nil;
//        LOG(@"sub layout： %@",self.extra);
//    }
//    
//    [super layoutSubviews];
//}
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//    [self setNeedsLayout];
//}

@end
