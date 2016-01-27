//
//  ScoreFlowSelection.h
//  Fanmore
//
//  Created by Cai Jiang on 3/14/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScoreFlowSelection;

@protocol FlowSelected <NSObject>

-(void)flowSelected:(ScoreFlowSelection*)selection;

@end

@interface ScoreFlowSelection : UILabel

@property(readonly) BOOL actived;
@property(weak) id<FlowSelected> delegate;
@property UIColor* backgroundCColor;
@property NSString* backgroundImageName;
-(void)activeSelection;
-(void)unactive;

@end
