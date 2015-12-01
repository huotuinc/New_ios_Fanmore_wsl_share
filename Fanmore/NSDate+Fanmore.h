//
//  NSDate+Fanmore.h
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Fanmore)

/**
 *  根据粉木耳标准的时间格式获取具体时间
 *  yyyy-MM-dd HH-mm-ss
 *
 *  @return 字符串
 */
-(NSString*)fmToString;

-(NSString*)fmHumenReadableString;

-(NSString*)fmStandString;
-(NSString*)fmStandStringDateOnly;
-(NSString*)fmStandStringDateOnlyChinese;
-(NSString*)fmStandStringDateOnlyDot;

-(BOOL)between:(NSDate*)start end:(NSDate*)end;

@end
