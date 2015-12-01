//
//  FFFanOpertationDelegate.h
//  Fanmore
//
//  Created by Cai Jiang on 1/10/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFCircularProgressView.h"
#import "FanOpertationDelegate.h"

@interface FFFanOpertationDelegate : NSObject <FanOpertationDelegate>


+(id)DelegateForFFCircularProgressView:(FFCircularProgressView*)view;
-(id)initWithFFCircularProgressView:(FFCircularProgressView*)view;

@end
