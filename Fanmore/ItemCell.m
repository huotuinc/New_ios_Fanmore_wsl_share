//
//  ItemCell.m
//  Fanmore
//
//  Created by Cai Jiang on 10/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "ItemCell.h"

@implementation NSDictionary (AllItemD)

-(NSDictionary*)newItemNewCount:(NSNumber *)count{
    return @{
             @"type":self[@"type"],
             @"name":self[@"name"],
//             @"desc":self[@"desc"],
//             @"exp":self[@"exp"],
//             @"storeTotal":self[@"storeTotal"],
//             @"store":self[@"store"],
             @"amount":$int([self[@"amount"]intValue]-1)
             };
}

-(int)getAllItemType{
    return [self[@"type"] intValue];
}

-(UIImage*)getAllItemImage{
    return [UIImage imageNamed:$str(@"daoju%d",[self getAllItemType])];
}

-(NSString*)getAllItemName{
    return self[@"name"];
}
-(NSString*)getAllItemDesc{
    return self[@"desc"];
}
-(NSNumber*)getAllItemPrice{
    return self[@"exp"];
}
-(NSNumber*)getAllItemStoreTotal{
    return self[@"storeTotal"];
}
-(NSNumber*)getAllItemStore{
    return self[@"store"];
}

@end

@implementation NSDictionary (MyItemD)

-(NSNumber*)getMyItemAmount{
    return self[@"amount"];
}

@end

@interface ItemCell()

@property(weak) NSDictionary* item;

@end

@implementation ItemCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(9, 8, 69, 69)];
    [self addSubview:iv];
    self.imageItem = iv;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(96, 8, 131, 21)];
    [label setFont:[UIFont systemFontOfSize:17]];
    [self addSubview:label];
    self.labelName = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(96, 32, 131, 21)];
    [label setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:label];
    self.labelPrice = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(96, 52, 131, 27)];
    [label setFont:[UIFont systemFontOfSize:11]];
    label.numberOfLines = 2;
    [label setTextColor:[UIColor lightGrayColor]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:label];
    self.labelDesc = label;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(235, 24, 77, 37)];
    [button setImage:[UIImage imageNamed:@"duihuan"] forState:UIControlStateNormal];
    [self addSubview:button];
    self.button = button;
    
    [self.button addTarget:self action:@selector(buyme) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

-(void)configData:(NSDictionary*)data path:(NSIndexPath *)indexPath{
    
    self.item = data;
    
    [self.imageItem setImage:[data getAllItemImage]];
    [self.labelName setText:[data getAllItemName]];
    [self.labelDesc setText:[data getAllItemDesc]];
    [self.labelPrice setText:$str(@"%@经验",[data getAllItemPrice])];
    //button
    
    // -1
    //duihuan duihuan2
    NSNumber* st = [data getAllItemStoreTotal];
    [self.button setEnabled:YES];
    if ($safe(st) && [st intValue]!=-1) {
        [self.button setTitle:$str(@"%@/%@",[data getAllItemStore],st) forState:UIControlStateNormal];
        if ([[data getAllItemStore] intValue]==0) {
            [self.button setTitle:@"今日售完" forState:UIControlStateNormal];
            [self.button setEnabled:NO];
        }
        [self.button setImage:nil forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"duihuan2"] forState:UIControlStateNormal];
    }else{
        [self.button setTitle:nil forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"duihuan"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    self.backgroundColor = (indexPath.row%2==1)?[UIColor whiteColor]:[UIColor colorWithHexString:@"#EAEAEA"];
}

-(void)buyme{
    [self.handler buyItem:self.item];
}

- (void)awakeFromNib {
    // Initialization code
    [self.button addTarget:self action:@selector(buyme) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation MyItemCell

@end
