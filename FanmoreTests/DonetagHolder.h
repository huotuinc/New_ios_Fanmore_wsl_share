//
//  DonetagHolder.h
//  Fanmore
//
//  Created by Cai Jiang on 2/21/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DonetagHolder <NSObject>

-(BOOL)isDone;
-(void)setDone:(BOOL)d;

@end
