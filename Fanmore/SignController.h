//
//  SignController.h
//  Fanmore
//
//  Created by Cai Jiang on 10/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignController : UIViewController

@property UIImage* lastImage;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIButton *buttonClose;

@property (weak, nonatomic) IBOutlet UIButton *buttonSign;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine1;

@property (weak, nonatomic) IBOutlet UIImageView *imageLine2;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine3;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine4;
@property (weak, nonatomic) IBOutlet UIImageView *imageC1;
@property (weak, nonatomic) IBOutlet UIImageView *imageC2;
@property (weak, nonatomic) IBOutlet UIImageView *imageC3;
@property (weak, nonatomic) IBOutlet UIImageView *imageC4;
@property (weak, nonatomic) IBOutlet UIImageView *imageC5;


@property (weak, nonatomic) IBOutlet UIImageView *imageLast;
@property (weak, nonatomic) IBOutlet UIView *viewMask;

@property (weak, nonatomic) IBOutlet UILabel *labelE1;
@property (weak, nonatomic) IBOutlet UILabel *labelE2;
@property (weak, nonatomic) IBOutlet UILabel *labelE3;
@property (weak, nonatomic) IBOutlet UILabel *labelE4;
@property (weak, nonatomic) IBOutlet UILabel *labelE5;
@property (weak, nonatomic) IBOutlet UILabel *labelMsg;
@property (weak, nonatomic) IBOutlet UILabel *labelX;
@property (weak, nonatomic) IBOutlet UIImageView *imageMao;
@property (weak, nonatomic) IBOutlet UILabel *labelMsg2;
@end
