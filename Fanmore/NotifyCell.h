//
//  NotifyCell.h
//  Fanmore
//
//  Created by Cai Jiang on 9/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef FanmoreDebug

@interface NSMutableDictionary (NotifyCell)

-(void)setNotifyId:(NSNumber*)id;
-(void)setNotifyTaskId:(NSNumber*)id;
-(void)setNotifyTaskStatus:(NSNumber*)id;
-(void)setNotifyType:(NSNumber*)id;
-(void)setNotifyTitle:(NSString*)id;
-(void)setNotifyDesc:(NSString*)id;
-(void)setNotifyTime:(NSString*)id;
-(void)setNotifyWebUrl:(NSString*)id;

@end

#endif

@interface NSDictionary (NotifyCell)

-(NSNumber*)getNotifyID;
-(NSString*)getNotifyTitle;
-(NSString*)getNotifyDesc;
-(NSString*)getNotifyTime;
-(NSNumber*)getNotifyType;
-(NSNumber*)getNotifyTaskId;
-(NSNumber*)getNotifyTaskStatus;
-(NSString*)getNotifyWebUrl;

@end

@interface NotifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imageTop;

-(void)config:(NSDictionary*)data;

@end
