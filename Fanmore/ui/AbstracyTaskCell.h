//
//  AbstracyTaskCell.h
//  Fanmore
//
//  Created by Cai Jiang on 6/16/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import "FmTableCell.h"
#import "Task.h"

@interface AbstracyTaskCell : FmTableCell

@property NSMutableArray* addBigRewardsViews;
@property NSMutableArray* rewards;

@property(nonatomic,strong) UIImageView* image;
@property(nonatomic,strong) UILabel* sendReward;
@property(nonatomic,strong) UILabel* browseReward;
@property(nonatomic,strong) UILabel* linkReward;

@property(nonatomic,strong) UILabel* sendRewardYes;
@property(nonatomic,strong) UILabel* browseRewardYes;
@property(nonatomic,strong) UILabel* linkRewardYes;

@property(nonatomic,strong) UILabel* sendCount;
@property(nonatomic,strong) UIImageView* imgSendPic;

@property(nonatomic,strong) UIImageView* tuzhang;
@property NSMutableDictionary* shareTypeImages;

@property(nonatomic,strong) UILabel* title;
@property(nonatomic,strong) UILabel* info;
@property(nonatomic,strong) UILabel* humanTime;
@property(nonatomic,strong) UILabel* totalScore;
@property(nonatomic,strong) UILabel* lastScore;

/**
 *  增加活动信息包括Label和Image
 */
-(void)addHuodongInformation;

-(void)updateHuodongInformation:(Task*)task;

/**
 *  联盟任务调整
 *
 *  @param reward <#reward description#>
 */
-(void)adjustForUnitTask:(NSNumber*)reward;

/**
 *  还原
 */
-(void)restoreForUnitTask;

/**
 *  更新左上角图片
 *
 *  @param image <#image description#>
 */
-(void)updateImageLeftTop:(UIImage*)image;
/**
 *  隐藏左上角图片
 */
-(void)hideImageLeftTop;
/**
 *  增加左上角图片
 */
-(void)addImageLeftTop;


+(UIImage*)DefaultImage;


/**
 *  增加头部信息
 *
 *   @return <#return value description#>
 *   @see title,info,updateImage:
 */
-(CGFloat)addHeaderInfo;

/**
 *  更新图片信息
 *
 *  @param url <#url description#>
 */
-(void)updateImage:(NSString*)url;

/**
 *  填充标题和info端信息
 *
 *  @param title <#title description#>
 *  @param info  <#info description#>
 */
-(void)updateHeaderInfo:(NSString*)title info:(NSString*)info;


/**
 *  增加收益详情 6宫格
 *
 *  @param type    <#type description#>
 *  @param yoffset <#yoffset description#>
 */
-(void)addRewards:(uint)type yoffset:(CGFloat)yoffset;
/**
 *  填充数值信息
 *
 *  @param type  <#type description#>
 *  @param value 会执行stringvalue方法
 */
-(void)updateRewards:(uint)type value:(id)value;


/**
 *  建立一个新的表格 分别显示 转发 浏览 外链
 *
 *  @param type    <#type description#>
 *  @param suffix  显示格式
 *  @param yoffset <#yoffset description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)addBigRewards:(NSUInteger)type suffix:(NSString*)suffix yoffset:(CGFloat)yoffset;
-(void)updateBigRewards:(NSUInteger)type send:(id)send browse:(id)browse link:(id)link;


/**
 *  增加 总积分 和剩余积分信息
 *
 *  @see totalScore,lastScore
 *  @param yoffset <#yoffset description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)addScoreInfo:(CGFloat)yoffset;
/**
 *  填充总积分剩余积分信息
 *
 *  @param total <#total description#>
 *  @param last  <#last description#>
 */
-(void)updateScoreInfo:(id)total last:(id)last;

/**
 *  增加一行信息 并且将储存生成的数据到指针
 *
 *  @param yoffset  <#yoffset description#>
 *  @param msg      <#msg description#>
 *  @param ptolabel <#ptolabel description#>
 *
 *  @return <#return value description#>
 */
-(CGFloat)addSimpleInfoOneLine:(CGFloat)yoffset msg:(NSString*)msg p:(UILabel**)ptolabel;

/**
 *  转发相关的uiviews
 *  该方法应该同endWithSendInfoAndTime一起维护
 *
 *  @return <#return value description#>
 */
-(NSArray*)uisendWithSendInfos;
/**
 *  所有因为endWithSendInfoAndTime而添加的uiviews
 *  该方法应该同endWithSendInfoAndTime一起维护
 *
 *  @return <#return value description#>
 */
-(NSArray*)uisendWithSendInfoAndTime;
/**
 *  加入转发信息和时间作为结尾
 *
 *  @param yoffset    <#yoffset description#>
 *  @param addRewards 是否显示收益详情
 *  @param sendInfo 是否显示转发信息
 *
 *  @return <#return value description#>
 */
-(CGFloat)endWithSendInfoAndTime:(CGFloat)yoffset addRewards:(BOOL)addRewards sendInfo:(BOOL)sendInfo;
/**
 *  更新时间和转发次数
 *
 *  @param time      可以为NSDate或者cell直接使用stringValue
 *  @param sendCount 可以为NSNumber或者cell直接使用stringValue
 */
-(void)updateTime:(id)time andSendCount:(id)sendCount;
/**
 *  更新已转发列表
 *
 *  @param sendlist <#sendlist description#>
 */
-(void)updateSendList:(NSString*)sendlist;

/**
 *  增加图章
 *
 *  @param type  类别0: 229, 0, 91, 72
 */
-(void)appendTuzhang:(NSUInteger)type;

/**
 *  更新图章信息
 *
 *  @param type   <#type description#>
 *  @param hidden <#hidden description#>
 *  @param image  <#image description#>
 */
-(void)updateTuzhang:(NSUInteger)type hidden:(BOOL)hidden image:(UIImage*)image;

@end
