//
//  StoreCell.m
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "StoreCell.h"
#import "HTTPRequestMoniter.h"
#import "AppDelegate.h"
#import "BlocksKit+UIKit.h"
#import "AppDelegate.h"
#import "FMUtils.h"

static UIImage* DefalutImage;

@interface StoreCell ()
@property(weak) Store* store;
@property(weak) UIImageView* image;
//@property UIImageView* guanzhuImage;
@property(weak) UIImageView* shoucangImage;
@property(weak) UILabel* title;
@property(weak) UILabel* taskCount;
@property HTTPRequestMoniter* lastRequest;
@end

@implementation StoreCell

+(UIImage*)DefaultImage{
    if (DefalutImage==NULL) {
        DefalutImage = [UIImage imageNamed:@"imgloding-full"];
    }
    return DefalutImage;
}

-(void)clickShoucang{
    [[[AppDelegate getInstance]getFanOperations]operFavorite:Nil block:^(NSString *msg, NSError *error) {
        if ($safe(error)) {
            [FMUtils alertMessage:self.superview.superview.superview msg:error.description];
        } else {
            [FMUtils alertMessage:self.superview.superview.superview msg:msg];
            [FMUtils favIconToogle:self.shoucangImage fav:[self.store.fav boolValue]];
        }
    } store:self.store];
}

- (void)fminitialization{
    [super fminitialization];
//    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, CGRectGetWidth(self.contentView.frame), 300);
    UIImageView* iimage;
    UILabel* label;
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    iimage.image = [self.class DefaultImage];
    [self addSubview:iimage];
    self.image = iimage;
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    iimage.image = [UIImage imageNamed:@"yuan_big"];
    [self addSubview:iimage];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(107, 12, 213, 21)];
    label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
    self.title = label;
    
    //    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(295, 100, 16, 10)];
    //    iimage.image = [UIImage imageNamed:@"jiantou_bigs"];
    //    [self addSubview:iimage];
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(97, 38, 207, 2)];
    iimage.image = [UIImage imageNamed:@"cibg"];
    [self addSubview:iimage];
    
    // 103,69 54,21
    //43
    
    //165 39  2 55
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(103+17, 48, 54, 21)];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.taskCount = label;
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(103+17, 69, 54, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"发布任务";
    [self addSubview:label];
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(165+35, 35, 1, 55)];
    iimage.image = [UIImage imageNamed:@"biaoge3右下"];
    [self addSubview:iimage];
    
    //中间70
    //35
    //34 17
    
    //188 43 24 24
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(188, 43, 24, 24)];
//    iimage.image = [UIImage imageNamed:@"guanzhu"];
//    [self addSubview:iimage];
//    self.guanzhuImage = iimage;
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(173, 69, 54, 21)];
//    label.font = [UIFont systemFontOfSize:13];
//    label.text = @"我要关注";
//    [self addSubview:label];
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(234, 39, 2, 55)];
//    iimage.image = [UIImage imageNamed:@"biaoge3右下"];
//    [self addSubview:iimage];
    
    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(255-17, 46, 24, 24)];
    iimage.image = [UIImage imageNamed:@"shangchangicon"];
    iimage.userInteractionEnabled = YES;
    
    __weak StoreCell* wself = self;
    void (^scWorker)() = ^(){
        [wself clickShoucang];
    };
    
    [iimage bk_whenTapped:scWorker];
    [self addSubview:iimage];
    self.shoucangImage = iimage;
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(244-17, 69, 54, 21)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"我要收藏";
    label.userInteractionEnabled = YES;
    [label bk_whenTapped:scWorker];
    [self addSubview:label];
    
    
    
    
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(92, 41, 218, 33)];
//    //    label.backgroundColor = [UIColor blueColor];
//    label.font = [UIFont systemFontOfSize:13];
//    label.numberOfLines = 4;
//    [self addSubview:label];
//    self.info = label;
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 82, 98, 21)];
//    iimage.image = [UIImage imageNamed:@"biaoge3左上"];
//    [self addSubview:iimage];
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(25, 82, 66, 21)];
//    label.font = [UIFont systemFontOfSize:9];
//    label.text=@"转发积分奖励";
//    [self addSubview:label];
//    label = [[UILabel alloc]initWithFrame:CGRectMake(85, 82, 20, 21)];
//    label.font = [UIFont systemFontOfSize:9];
//    label.textColor=[UIColor redColor];
//    [self addSubview:label];
//    self.sendReward = label;
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(111, 82, 98, 21)];
//    iimage.image = [UIImage imageNamed:@"biaoge3左上"];
//    [self addSubview:iimage];
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(119, 82, 64, 21)];
//    label.font = [UIFont systemFontOfSize:9];
//    label.text=@"浏览积分奖励";
//    [self addSubview:label];
//    label = [[UILabel alloc]initWithFrame:CGRectMake(183, 82, 20, 21)];
//    label.font = [UIFont systemFontOfSize:9];
//    label.textColor=[UIColor redColor];
//    [self addSubview:label];
//    self.browseReward = label;
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(211, 82, 98, 21)];
//    iimage.image = [UIImage imageNamed:@"biaoge3右上"];
//    [self addSubview:iimage];
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(223, 82, 64, 21)];
//    label.font = [UIFont systemFontOfSize:9];
//    label.text=@"外链积分奖励";
//    [self addSubview:label];
//    label = [[UILabel alloc]initWithFrame:CGRectMake(283, 82, 20, 21)];
//    label.font = [UIFont systemFontOfSize:9];
//    label.textColor=[UIColor redColor];
//    [self addSubview:label];
//    self.linkReward = label;
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(13, 102, 296, 2)];
//    iimage.image = [UIImage imageNamed:@"cibg"];
//    [self addSubview:iimage];
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 111, 12, 12)];
//    iimage.image = [UIImage imageNamed:@"time"];
//    [self addSubview:iimage];
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(37, 106, 157, 21)];
//    label.font = [UIFont systemFontOfSize:8];
//    [self addSubview:label];
//    self.humanTime = label;
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(239, 106, 19, 21)];
//    label.font = [UIFont systemFontOfSize:8];
//    label.text=@"转发";
//    [self addSubview:label];
//    
//    iimage = [[UIImageView alloc]initWithFrame:CGRectMake(261, 110, 11, 10)];
//    iimage.image = [UIImage imageNamed:@"zhuanfa"];
//    [self addSubview:iimage];
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(280, 106, 30, 21)];
//    label.font = [UIFont systemFontOfSize:8];
//    [self addSubview:label];
//    self.sendCount = label;
}

-(void)configureStore:(Store*)store{
    self.store = store;
    self.title.text = store.name;
    self.taskCount.text = $str(@"%@",store.taskCount);
    
    self.image.image = [self.class DefaultImage];
//    self.guanzhuImage.image = [UIImage imageNamed:@"guanzhu"];
    [FMUtils favIconToogle:self.shoucangImage fav:[self.store.fav boolValue]];
    
    if (self.lastRequest) {
        [self.lastRequest cancel];
        self.lastRequest = nil;
    }
    self.lastRequest =
    [[AppDelegate getInstance]downloadImage:store.logo handler:^(UIImage *image, NSError *error) {
        self.image.image = image;
        self.lastRequest = nil;
    } asyn:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
