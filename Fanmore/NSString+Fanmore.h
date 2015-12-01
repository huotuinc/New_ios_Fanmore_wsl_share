//
//  NSString+Fanmore.h
//  Fanmore
//
//  Created by Cai Jiang on 1/9/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Fanmore)

/**
 *  根据粉木耳标准的时间格式获取具体时间
 *  yyyy-MM-dd HH-mm-ss
 *
 *  @return Date
 */
-(NSDate*)fmToDate;
-(NSDate*)fmToDate2;

- (NSString*)encodeURL;

-(BOOL)isUserName;

-(BOOL)isMobileNumber;

-(BOOL)isPassword;

-(NSString*)parameterFromQuery:(NSString*)key;

@end
