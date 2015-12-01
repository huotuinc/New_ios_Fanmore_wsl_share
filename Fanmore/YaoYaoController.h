//
//  YaoYaoController.h
//  Fanmore
//
//  Created by Cai Jiang on 10/18/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YaoYaoController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageUp;
@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageShang;
@property (weak, nonatomic) IBOutlet UIImageView *imageXia;
@property (weak, nonatomic) IBOutlet UIImageView *imageSex;

@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicMask;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelSent;
@property (weak, nonatomic) IBOutlet UIButton *buttonOk;
@end
