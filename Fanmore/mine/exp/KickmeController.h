//
//  KickmeController.h
//  Fanmore
//
//  Created by Cai Jiang on 10/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KickConverView.h"

@interface KickmeController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *viewAnswer;
@property (weak, nonatomic) IBOutlet KickConverView *viewControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageLight;
@property (weak, nonatomic) IBOutlet UIButton *buttonAgain;
@property (weak, nonatomic) IBOutlet UILabel *labelAnswer;

@end
