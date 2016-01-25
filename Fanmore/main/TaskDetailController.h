//
//  TaskDetailController.h
//  Fanmore
//
//  Created by Cai Jiang on 1/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "SendTask.h"


@interface TaskDetailView1 : UIView
@property (weak, nonatomic) UIImageView* image;
@property (weak, nonatomic) UIImageView* shoucangImage;
@property (weak, nonatomic) UILabel* title;
@property (weak, nonatomic) UILabel* allScore;
@property (weak, nonatomic) UILabel* lastScore;
@property (weak, nonatomic) UILabel* shoucangLabel;
@end

@interface TaskDetailBaseScore : UIView
-(id)initWithCoder:(NSCoder *)aDecoder andType:(uint)type;
@property (weak, nonatomic) UILabel *browse;
@property (weak, nonatomic) UILabel *send;
@property (weak, nonatomic) UILabel *link;
@end

@interface TaskDetailAward : TaskDetailBaseScore

@end

@interface TaskDetailScore : TaskDetailBaseScore

@end

@interface TaskDetailController : UITableViewController<UITableViewDataSource,UIScrollViewDelegate,SendTask>
@property (weak, nonatomic) IBOutlet TaskDetailView1 *detail1;
@property (weak, nonatomic) IBOutlet TaskDetailAward *viewAward;
@property (weak, nonatomic) IBOutlet TaskDetailScore *viewScore;

@property(weak) Task* task;
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (weak, nonatomic) IBOutlet UILabel *sendCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgSendPic;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *btyizhuanfa;
@property (weak, nonatomic) IBOutlet UIButton *btqiangwan;
@property (weak, nonatomic) IBOutlet UIImageView *sendIcon;

//@property (weak, nonatomic) IBOutlet UITableView *coreTableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageQuestion;
@property (weak, nonatomic) IBOutlet UIImageView *imageBolan;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundBottom;

@end

