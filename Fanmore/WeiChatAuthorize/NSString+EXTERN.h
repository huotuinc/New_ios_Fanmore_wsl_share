//
//  NSString+EXTERN.h
//  fanmore---
//
//  Created by lhb on 15/5/29.
//  Copyright (c) 2015年 HT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EXTERN)


/**手机号正则表达式判断*/
+ (BOOL) checkTel:(NSString *) phoneNumber;

/**浮点数小数点处理*/
+(NSString *)xiaoshudianweishudeal:(CGFloat)aac;

@end
