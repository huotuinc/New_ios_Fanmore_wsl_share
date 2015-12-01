//
//  MessageCell.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FmTableCell.h"
@class MessageFrame;

@interface MessageCell : FmTableCell

@property (nonatomic, strong) MessageFrame *messageFrame;

@end
