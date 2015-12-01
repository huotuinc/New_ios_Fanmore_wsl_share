//
//  ExpReceiveView.h
//  Fanmore
//
//  Created by Cai Jiang on 10/22/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpReceiveView : UIView

+(instancetype)showView:(NSNumber*)exp;

@property (weak, nonatomic) IBOutlet UILabel *labelExp;
@end
