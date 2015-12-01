//
//  LoaderController.h
//  Fanmore
//
//  Created by Cai Jiang on 1/8/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFFanOpertationDelegate.h"

@interface LoaderController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet FFCircularProgressView *pview;

@end
