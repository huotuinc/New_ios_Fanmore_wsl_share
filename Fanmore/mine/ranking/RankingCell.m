//
//  RankingCell.m
//  Fanmore
//
//  Created by Cai Jiang on 9/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "RankingCell.h"

#ifdef FanmoreDebug
@implementation NSMutableDictionary (Ranking)

-(void)setupRankingValue:(NSString *)value names:(NSString *)names{
    self[@"value"] = value;
    self[@"names"] = names;
}
@end
#endif

@implementation NSDictionary (Ranking)

-(NSString*)getRankingValue{
    return self[@"value"];
}

-(NSString*)getFirstRankingName{
    NSString* names = self[@"names"];
    NSArray* datas = [names componentsSeparatedByString:@","];
    return datas[0];
}

-(NSString*)getOtherRankingNames{
    NSString* names = self[@"names"];
    NSArray* datas = [names componentsSeparatedByString:@","];
    if (datas.count==1) {
        return 0;
    }
    datas = [datas subarrayWithRange:NSMakeRange(1, datas.count-1)];
    return [datas componentsJoinedByString:@","];
}

@end

@interface RankingCell ()

@property(weak) UIImageView* number1;
@property(weak) UIImageView* number2;

@end


@implementation RankingCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIImage*)numbertToImage:(NSUInteger)number{
    return [UIImage imageNamed:$str(@"suzi%d",number)];
}

-(void)config:(NSUInteger)row myrank:(NSNumber *)myrank data:(NSDictionary *)data type:(uint)type{
    BOOL hi = [myrank intValue]-1==row;
    if (row==0) {
        if (hi) {
            [self.imageBackground setImage:[UIImage imageNamed:@"gaoliangtop"]];
        }else
            [self.imageBackground setImage:[UIImage imageNamed:@"listntop1"]];
    }else{
        BOOL a = row%2==0;
        if (a) {
            if (hi) {
                [self.imageBackground setImage:[UIImage imageNamed:@"listnA-hi"]];
            }else{
                [self.imageBackground setImage:[UIImage imageNamed:@"listnA"]];
            }
        }else{
            if (hi) {
                [self.imageBackground setImage:[UIImage imageNamed:@"listnB-hi"]];
            }else{
                [self.imageBackground setImage:[UIImage imageNamed:@"listnB"]];
            }
        }
    }
    
    [self.number1 removeFromSuperview];
    [self.number2 removeFromSuperview];
    
    NSUInteger number = row+1;
    if (number>=10) {
        NSUInteger y = number%10;
        NSUInteger s = number/10;
        
        UIImageView* image = [[UIImageView alloc] initWithImage:[self numbertToImage:s]];
        [image offset:15 y:12];
        [self addSubview:image];
        self.number1 = image;
        
        image = [[UIImageView alloc] initWithImage:[self numbertToImage:y]];
        [image offset:30 y:12];
        [self addSubview:image];
        self.number2 = image;
    }else{
        UIImageView* image = [[UIImageView alloc] initWithImage:[self numbertToImage:number]];
        [image offset:23 y:12];
        [self addSubview:image];
        self.number1 = image;
    }
    
//    NSScanner* scanner = [NSScanner scannerWithString:[data getRankingValue]];
//    int value = 0;
//    [scanner scanInt:&value];
    
    NSString* valueString = $str(@"%@",[data getRankingValue]);
    
    NSString* unit = @[@"积分",@"积分",@"积分",@"徒弟"][type];
    
//    NSString* unit  = [[data getRankingValue] substringFromIndex:valueString.length];
//    LOG(@"%@ %@",valueString,unit);
    
    [self.labelValue setText:valueString];
    [self.labelUnit setText:unit];
        
    NSString* others = [data getOtherRankingNames];
    if (others) {
        [self.labelOnlyOne hidenme];
        [self.labelNormalFirstOne showme];
        [self.labelNormalOthers showme];
        
        [self.labelNormalFirstOne setText:[data getFirstRankingName]];
        [self.labelNormalOthers setText:others];
    }else{
        [self.labelOnlyOne showme];
        [self.labelNormalFirstOne hidenme];
        [self.labelNormalOthers hidenme];
        
        [self.labelOnlyOne setText:[data getFirstRankingName]];
    }
}

@end
