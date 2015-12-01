//
//  SecureHelper.h
//  Fanmore
//
//  Created by Cai Jiang on 4/11/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecureHelper : NSObject

+ (NSData*) rsaEncryptData:(NSData*) data;
+ (NSData*) rsaEncryptString:(NSString*) string;

@end
