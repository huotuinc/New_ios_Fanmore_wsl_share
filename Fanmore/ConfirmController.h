//
//  ConfirmController.h
//  Fanmore
//
//  Created by Cai Jiang on 2/25/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *view;

+(instancetype)confirm:(UIViewController*)parent message:(NSString*)message block:(void (^)())block;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIView *btok;
@property (strong, nonatomic) IBOutlet UIView *btcancel;

@end
