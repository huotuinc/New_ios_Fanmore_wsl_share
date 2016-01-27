//
//  Paging.h
//  Fanmore
//
//  Created by Cai Jiang on 2/17/14.
//  Copyright (c) 2014 Cai Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  典型的就是
 *  pageIndex (uint),pageSize (uint)
 */
@interface Paging : NSObject

@property uint pageIndex;
@property uint pageSize;
@property NSDictionary* parameters;

+(instancetype)defaultPaging;
+(instancetype)paging:(uint)pageIndex pageSize:(uint)pageSize;
+(instancetype)paging:(uint)pageSize parameters:(NSDictionary*)parameters;

-(id)initWithData:(uint)pageIndex pageSize:(uint)pageSize;
-(id)initWithData:(uint)pageSize parameters:(NSDictionary*)parameters;
-(void)toParameters:(NSMutableDictionary*)p;

@end
