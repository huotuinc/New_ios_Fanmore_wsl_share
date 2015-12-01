//
//  KickConverView.h
//  Fanmore
//
//  Created by Cai Jiang on 10/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol KickKnowAwre <NSObject>

-(void)answerGetted;

@end

@interface KickConverView : UIView
{
    CGPoint previousTouchLocation;
    CGPoint currentTouchLocation;
    
    CGImageRef hideImage;
    CGImageRef scratchImage;
    
    CGContextRef contextMask;
}
@property(weak) id<KickKnowAwre> delegate;

@property (nonatomic, assign) float percentAccomplishment;
@property (nonatomic, assign) float sizeBrush;

@property (nonatomic, strong) UIView *hideView;

@property CGRect answerRect;

- (void)setHideView:(UIView *)hideView;

@end
